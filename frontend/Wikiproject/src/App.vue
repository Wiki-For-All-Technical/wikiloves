<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const name = ref('')
const responseMsg = ref('')
const users = ref([])

// Fetch all users from backend
const fetchUsers = async () => {
  const res = await axios.get('http://127.0.0.1:5000/api/users')
  users.value = res.data
}

// Send name to backend
const sendData = async () => {
  try {
    const res = await axios.post('http://127.0.0.1:5000/api/data', { name: name.value })
    responseMsg.value = res.data.reply
    name.value = ''
    await fetchUsers() // refresh the list after sending
  } catch (err) {
    console.error(err)
    responseMsg.value = 'Error sending data 😢'
  }
}

// Fetch existing users on page load
onMounted(fetchUsers)
</script>

<template>
  <div style="text-align:center; padding-top: 50px;">
    <h2>Send Data from Vue to Flask</h2>
    <input
      v-model="name"
      type="text"
      placeholder="Enter your name"
      style="padding:8px; border-radius:5px;"
    />
    <button @click="sendData" style="margin-left:10px; padding:8px 15px;">Send</button>

    <p style="margin-top:20px;">{{ responseMsg }}</p>

    <h3 style="margin-top:40px;">Saved Users:</h3>
    <ul style="list-style:none; padding:0;">
      <li v-for="user in users" :key="user.id">
        {{ user.id }}. {{ user.name }}
      </li>
    </ul>
  </div>
</template>
