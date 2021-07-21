Import-Module pure-pwsh
Import-Module posh-git

# Pure-pwsh colors
$pure.PwdColor = '1;36'
$pure.PromptColor = '1;32'
$pure.BranchColor = '1;35'
$pure.RemoteColor = '34'
$pure.DirtyColor = '31'

# Add branch icon
# Inbuilt branch name is bugged on new git repos
$pure.BranchFormatter = {
  param ($n)
  ($n ? ' ' + (git branch --show-current) : '')
}

# Customise prompt
$pure.PrePrompt = {
    param ($user, $cwd, $git, $slow)
    "$user{0}$cwd{1}$git{2}$slow `n" -f
    ($user ? ' ' : ''),
    ($git ? ' on ' : ''),
    ($slow ? ' took ' : '')
}

# TODO: make custom pwd based on fish prompt

# Vi mode not supported yet
Set-PSReadLineOption -EditMode Emacs

# Dracula readline configuration. Requires version 2.0, if you have 1.2 convert to `Set-PSReadlineOption -TokenType`
Set-PSReadlineOption -Color @{
    "Command" = [ConsoleColor]::Green
    "Parameter" = [ConsoleColor]::Gray
    "Operator" = [ConsoleColor]::Magenta
    "Variable" = [ConsoleColor]::White
    "String" = [ConsoleColor]::Yellow
    "Number" = [ConsoleColor]::Blue
    "Type" = [ConsoleColor]::Cyan
    "Comment" = [ConsoleColor]::DarkCyan
}

# Fish like autosuggestions
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -Colors @{ InlinePrediction = '#808080' }

# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Linux like ls
if ($host.Name -eq 'ConsoleHost')
{
    function ls_git { & 'C:\Program Files\Git\usr\bin\ls' --color=auto -hF $args }
    Set-Alias -Name ls -Value ls_git -Option AllScope
}
