import "phoenix_html"
import {
  Socket,
  Presence
} from "phoenix"

let user = document.getElementById("user").innerText
let socket = new Socket("/socket", {
  params: {
    user: user
  }
})
socket.connect()

let presences = {}

// Convert date to locale string
let formartedTimestamp = (Ts) => {
  let date = new Date(Ts)
  return date.toLocaleString()
}

//Parse data form Presence.track
let listBy = (user, {
  metas: metas
}) => {
  return {
    user: user,
    onlineAt: formartedTimestamp(metas[0].online_at)
  }
}

// Render User online presence_state
let userList = document.getElementById("userList")
let render = (presences) => {
  userList.innerHTML = Presence.list(presences, listBy)
    .map(presence => `
        <li>
          ${presence.user}
          <br>
          <small>online since ${presence.onlineAt}</small>
        </li>
      `)
    .join("")
}

// Callback fom Presence
let room = socket.channel("room:lobby")
room.on("presence_state", state => {
  presences = Presence.syncState(presences, state)
  render(presences)
})

room.on("presence_diff", diff => {
  presences = Presence.syncDiff(presences, diff)
  render(presences)
})

room.on("message:new", message => {
  renderMessage(message)
})

room.join()

// Enter key listener
let messageInput = document.getElementById("newMessage")
messageInput.addEventListener("keypress", (e) => {
  if (e.keyCode == 13 && messageInput.value != "") {
    room.push("message:new", messageInput.value)
    messageInput.value = ""
  }
})

// Render Message to chat screen
let messageList = document.getElementById("messageList")
let renderMessage = (message) => {
  let messageElement = document.createElement("li")
  messageElement.innerHTML = `
    <b>${message.user}</b>
    <i>${formartedTimestamp(message.timestamp)}</i>
    <p>${message.body}</p>
  `

  messageList.appendChild(messageElement)
  messageList.scrollTop = messageList.scrollHeight;
}
