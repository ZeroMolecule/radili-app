importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

const firebaseConfig = {
  apiKey: "AIzaSyCZqEjaxBE8e10Kz92InwItfjIuYEnfRyE",
  authDomain: "radi-li.firebaseapp.com",
  projectId: "radi-li",
  storageBucket: "radi-li.appspot.com",
  messagingSenderId: "51796373713",
  appId: "1:51796373713:web:f29119969e1ec0b71015f0",
  measurementId: "G-HRT4PT7SL2"
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();