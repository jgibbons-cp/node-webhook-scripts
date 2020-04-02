module.exports = [
  {
    path: "/<endpoint>",
    command: "sh /home/<user>/<script_name>",
    cwd: "/home/<user>/",
    method: "post"
  }
]
