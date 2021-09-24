importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyDGF_389Ur28zle816UemZJStWD9XxoAZo",
  authDomain: "unicorn-46da5.firebaseapp.com",
  projectId: "unicorn-46da5",
  storageBucket: "unicorn-46da5.appspot.com",
  messagingSenderId: "58000072263",
  appId: "1:58000072263:web:720863e69a91e04f251b62",
  measurementId: "G-S183JTE02J",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});
