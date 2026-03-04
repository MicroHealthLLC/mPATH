import { initializeApp } from 'firebase/app';
import { getFirestore, collection, doc, getDoc, getDocs, addDoc, updateDoc, deleteDoc } from 'firebase/firestore';


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
  const app = initializeApp(firebaseConfig);
//   const analytics = getAnalytics(app);
  
  const db = getFirestore(app);
  const usersCollection = collection(db, 'contracts');

  export const createUser = user => {
      return addDoc(usersCollection, user)
  }


  export const getUser = async id => {
      const docRef = doc(usersCollection, id)
      const docSnap = await getDoc(docRef)
      return docSnap.exists() ? docSnap.data() : null
  }

  export const updateUser = (id, user) => {
      const docRef = doc(usersCollection, id)
      return updateDoc(docRef, user)
  }

  export const deleteUser = id => {
    const docRef = doc(usersCollection, id)
    return deleteDoc(docRef)
}

export const getContracts = async () => {
    const querySnapshot = await getDocs(usersCollection)
    return querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }))
}

// export const useLoadUsers = () => {
//   const users = ref([])
//   const close = usersCollection.onSnapshot(snapshot => {
//       users.value = snapshot.doc.map(doc => ({ id: doc.id, ...doc.data() }))
//   })
//   onUnmounted(close)
//   return users
// }