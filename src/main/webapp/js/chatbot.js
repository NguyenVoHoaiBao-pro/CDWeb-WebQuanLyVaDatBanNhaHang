
(function () {
  "use strict";

  function toggleChat() {
    var chatBox = document.getElementById("chat-box");
    if (!chatBox) return;
    chatBox.style.display = chatBox.style.display === "flex" ? "none" : "flex";
  }

  function sendMessage() {
    var input = document.getElementById("chat-input");
    var box = document.getElementById("chat-messages");
    if (!input || !box) return;

    var msg = input.value.trim();
    if (msg === "") return;

    var userDiv = document.createElement("div");
    userDiv.className = "user-msg";
    userDiv.innerText = msg;
    box.appendChild(userDiv);
    box.scrollTop = box.scrollHeight;
    input.value = "";

    var apiUrl = window.CHAT_API_URL;
    if (!apiUrl) {
      console.warn("CHAT_API_URL not defined");
      return;
    }

    fetch(apiUrl, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "message=" + encodeURIComponent(msg),
    })
      .then(function (response) {
        return response.text();
      })
      .then(function (data) {
        var aiDiv = document.createElement("div");
        aiDiv.className = "ai-msg";
        aiDiv.innerHTML = data;
        box.appendChild(aiDiv);
        box.scrollTop = box.scrollHeight;
      })
      .catch(function () {
        var err = document.createElement("div");
        err.className = "ai-msg";
        err.innerText = "Không kết nối được chatbot";
        box.appendChild(err);
      });
  }

  window.toggleChat = toggleChat;
  window.sendMessage = sendMessage;

  document.addEventListener("DOMContentLoaded", function () {
    var chatInput = document.getElementById("chat-input");
    if (chatInput) {
      chatInput.addEventListener("keypress", function (e) {
        if (e.key === "Enter") sendMessage();
      });
    }
  });
})();
