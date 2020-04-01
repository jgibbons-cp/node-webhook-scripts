module.exports = [
  {
    path: "/$PATH",
    command: "sh /home/$USER/$SCRIPT_NAME",
    cwd: "/home/$USER/",
    method: "post"
  }
]
