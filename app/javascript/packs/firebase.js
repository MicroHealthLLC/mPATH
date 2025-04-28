import { initializeApp } from 'firebase/app';
import { getFirestore, collection, doc, getDoc, updateDoc, deleteDoc, addDoc } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: "mh-test-3a298.firebaseapp.com",
  projectId: "mh-test-3a298",
  storageBucket: "mh-test-3a298.appspot.com",
  messagingSenderId: "27896897832",
  appId: "1:27896897832:web:a663fb5f41d20a5b94301d",
  measurementId: process.env.FIREBASE_MEASUREMENT_ID
};

const app = initializeApp(firebaseConfig);

const db = getFirestore(app);

const usersCollection = collection(db, 'contracts');

export const createUser = async (user) => {
  return await addDoc(usersCollection, user);
};

export const dbCollection = () => {
  return collection(db, 'contracts');
};

export const getUser = async (id) => {
  const userDoc = await getDoc(doc(db, 'contracts', id));
  return userDoc.exists() ? userDoc.data() : null;
};

export const updateUser = async (id, user) => {
  return await updateDoc(doc(db, 'contracts', id), user);
};

export const deleteUser = async (id) => {
  return await deleteDoc(doc(db, 'contracts', id));
};
