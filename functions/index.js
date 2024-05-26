const {onSchedule} = require("firebase-functions/v2/scheduler");
const {logger} = require("firebase-functions");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
const INACTIVITY_THRESHOLD = Date.now() - 30 * 24 * 60 * 60 * 1000; // 30 days

admin.initializeApp();

// [SEND NOTIFICATION] - This part will send a notification to the recipient when a new message is sent.

exports.onMessageCreate = onDocumentCreated("chats/{chatId}/messages/{messageId}", async (event) =>  {

    const messageModel = event.data.data();

    const recipientId = messageModel.recipientId;

    const tokensSnapshot = await admin.firestore().collection('users').doc(recipientId).get();

    if (!tokensSnapshot.exists) {
        return null;
    }

    const token = tokensSnapshot.data().token;

    const message = {
        notification: {
            title: messageModel.senderId ? messageModel.senderId : 'New Message',
            body: messageModel.message ? messageModel.message : 'You have a new message!',
        },
        token: token,
    };

    try {
        await admin.messaging().send(message);
        logger.log('Message sent:', message);
    } catch (error) {
        logger.error('Error sending notification:', error);
    }

    return null;
});






//[DELETE INACTIVE USERS] - This part will delete users who have not signed in for the last 30 days.

const PromisePool = require("es6-promise-pool").default;
const MAX_CONCURRENT = 3;

// Run once a month, to clean up the users
exports.accountCleanup = onSchedule("1 of month 00:00", async () => {

    const inactiveUsers = await getInactiveUsers();

    const { results, errors } = await PromisePool
        .withConcurrency(MAX_CONCURRENT)
        .for(inactiveUsers)
        .process(deleteInactiveUser);

    if (errors.length > 0) {
        logger.error('Errors occurred during user cleanup', errors);
    } else {
        logger.log('User cleanup finished successfully', results);
    }
});


async function getInactiveUsers(users = [], nextPageToken) {
    const result = await admin.auth().listUsers(1000, nextPageToken);
    // Find users that have not signed in in the last 30 days.
    const inactiveUsers = result.users.filter(
        (user) =>
            Date.parse(
                user.metadata.lastRefreshTime || user.metadata.lastSignInTime,
            ) <
            INACTIVITY_THRESHOLD,
    );

    users = users.concat(inactiveUsers);

    if (result.pageToken) {
        return getInactiveUsers(users, result.pageToken);
    }

    return users;
}



async function deleteInactiveUser(inactiveUsers) {
    if (inactiveUsers.length > 0) {
        const userToDelete = inactiveUsers.pop();
        try {
            // Delete chat documents where participantIds array contains the user UID
            const chatsRef = admin.firestore().collection('chats');
            const chatsSnapshot = await chatsRef.where('participantIds', 'array-contains', userToDelete.uid).get();
            const deletePromises = [];

            for (const chatDoc of chatsSnapshot.docs) {
                // Delete messages in the subcollection
                const messagesSnapshot = await chatDoc.ref.collection('messages').get();
                messagesSnapshot.forEach(messageDoc => {
                    deletePromises.push(messageDoc.ref.delete());
                });

                // Delete the chat document itself
                deletePromises.push(chatDoc.ref.delete());
            }

            await Promise.all(deletePromises);

            logger.log(
                "Deleted chats for user account",
                userToDelete.uid,
            );

            // Delete the user account
            await admin.auth().deleteUser(userToDelete.uid);

            logger.log(
                "Deleted user account",
                userToDelete.uid,
                "because of inactivity",
            );
        } catch (error) {
            logger.error(
                "Deletion of inactive user account",
                userToDelete.uid,
                "failed:",
                error,
            );
        }
    } else {
        return null;
    }
}