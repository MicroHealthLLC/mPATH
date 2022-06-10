import firebase from 'firebase'
import 'firebase/firestore';


const firebaseConfig = {
    apiKey: process.env.FIREBASE_API_KEY,
    authDomain: "mh-test-3a298.firebaseapp.com",
    projectId: "mh-test-3a298",
    storageBucket: "mh-test-3a298.appspot.com",
    messagingSenderId: "27896897832",
    appId: "1:27896897832:web:a663fb5f41d20a5b94301d",
    measurementId: "${config.measurementId}"
  };
  
  // Initialize Firebase
  const app = firebase.initializeApp(firebaseConfig);
//   const analytics = getAnalytics(app);
  
  const db = app.firestore()
  const usersCollection = db.collection('contracts')

  export const createUser = user => {
      return usersCollection.add(user)
  }

  export const dbCollection = () => {
    return db.collection('contracts')
  }


  export const getUser = async id => {
      const user = await usersCollection.doc(id).get()
      return user.exists ? user.data() : null
  }

  export const updateUser = (id, user) => {
      return usersCollection.doc(id).update(user)
  }

  export const deleteUser = id => {
    return usersCollection.doc(id).delete()
}

// export const useLoadUsers = () => {
//   const users = ref([])
//   const close = usersCollection.onSnapshot(snapshot => {
//       users.value = snapshot.doc.map(doc => ({ id: doc.id, ...doc.data() }))
//   })
//   onUnmounted(close)
//   return users
// }