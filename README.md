# devcontainer-features
Features for Devcontainer

```json
[ 
    {
        "command": "workbench.action.createTerminalEditor",
        "key": "Ctrl+K T",
        "args": {
            "location": 2,
            "config": {
                "name": "Terminal",
                "executable": "tmux"
            }
        }
    },
    {
        "key": "Ctrl+K V",
        "command": "workbench.action.createTerminalEditor",
        "args": {
            "location": 2,
            "config": {
                "name": "Neovim",
                "executable": "nvim"
            }
        }
    }
]
```