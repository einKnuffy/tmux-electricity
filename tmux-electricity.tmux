#!/usr/bin/env bash

# Function to get tmux option value or a default value
tmux_get() {
    local value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

# Function to set tmux options
tmux_set() {
    tmux set-option -gq "$1" "$2"
}

# Define various options for customization
right_arrow_icon=$(tmux_get '@tmux_power_right_arrow_icon' '')
left_arrow_icon=$(tmux_get '@tmux_power_left_arrow_icon' '')
upload_speed_icon=$(tmux_get '@tmux_power_upload_speed_icon' '')
download_speed_icon=$(tmux_get '@tmux_power_download_speed_icon' '')
session_icon="$(tmux_get '@tmux_power_session_icon' '')"
user_icon="$(tmux_get '@tmux_power_user_icon' '')"
time_icon="$(tmux_get '@tmux_power_time_icon' '')"
date_icon="$(tmux_get '@tmux_power_date_icon' '')"
show_upload_speed="$(tmux_get @tmux_power_show_upload_speed false)"
show_download_speed="$(tmux_get @tmux_power_show_download_speed false)"
show_web_reachable="$(tmux_get @tmux_power_show_web_reachable false)"
prefix_highlight_pos=$(tmux_get @tmux_power_prefix_highlight_pos)
time_format=$(tmux_get @tmux_power_time_format '%T')
date_format=$(tmux_get @tmux_power_date_format '%F')
TC=$(tmux_get '@tmux_power_theme' '#af87ff')

# Color definitions
G01=#080808
G02=#121212
G03=#1c1c1c
G04=#262626
G05=#303030
G06=#3a3a3a
G07=#444444
G08=#4e4e4e
G09=#585858
G10=#626262
G11=#6c6c6c
G12=#767676
FG="$G10"
BG=default #"$G04"

# Set basic status bar options
tmux_set status-interval 1
tmux_set status on
tmux_set status-fg "$FG"
tmux_set status-bg default #"$BG"
tmux_set status-style bg=default
tmux_set status-attr none

# Configure tmux-prefix-highlight
tmux_set @prefix_highlight_fg "$BG"
tmux_set @prefix_highlight_bg "$FG"
tmux_set @prefix_highlight_show_copy_mode 'on'
tmux_set @prefix_highlight_copy_mode_attr "fg=$TC,bg=$BG,bold"
tmux_set @prefix_highlight_output_prefix "#[fg=$TC]#[bg=$BG]$left_arrow_icon#[bg=$TC]#[fg=$BG]"
tmux_set @prefix_highlight_output_suffix "#[fg=$TC]#[bg=$BG]$right_arrow_icon"

# Define left and right side of the status bar
tmux_set status-left-bg "$G04"
tmux_set status-left-fg "G12"
tmux_set status-left-length 150

user=$(whoami)
LS="#[fg=$G04,bg=$TC,bold] $user_icon $user@#h #[fg=$TC,bg=$G06,nobold]$right_arrow_icon#[fg=$TC,bg=$G06] $session_icon #S "
if [ "$show_upload_speed" == "true" ]; then
    LS="$LS#[fg=$G06,bg=$G05]$right_arrow_icon#[fg=$TC,bg=$G05] $upload_speed_icon #{upload_speed} #[fg=$G05,bg=$BG]$right_arrow_icon"
else
    LS="$LS#[fg=$G06,bg=$BG]$right_arrow_icon"
fi
if [[ $prefix_highlight_pos == 'L' || $prefix_highlight_pos == 'LR' ]]; then
    LS="$LS#{prefix_highlight}"
fi

tmux_set status-left "$LS"

tmux_set status-right-bg "$BG"
tmux_set status-right-fg "G12"
tmux_set status-right-length 150
RS="#[fg=$G06]$left_arrow_icon#[fg=$TC,bg=$G06] $time_icon $time_format #[fg=$TC,bg=$G06]$left_arrow_icon#[fg=$G04,bg=$TC] $date_icon $date_format "
if [ "$show_download_speed" == "true" ]; then
    RS="#[fg=$G05,bg=$BG]$left_arrow_icon#[fg=$TC,bg=$G05] $download_speed_icon #{download_speed} $RS"
fi
if [ "$show_web_reachable" == "true" ]; then
    RS=" #{web_reachable_status} $RS"
fi
if [[ $prefix_highlight_pos == 'R' || $prefix_highlight_pos == 'LR' ]]; then
    RS="#{prefix_highlight}$RS"
fi

tmux_set status-right "$RS"

# Set window and pane options
tmux_set window-status-format " #I:#W#F "
tmux_set window-status-current-format "#[fg=$G06,bg=$G06]$right_arrow_icon#[fg=$TC,bold] #I:#W#F #[fg=$BG,bg=$BG,nobold]$right_arrow_icon" # "#[fg=$BG,bg=$G06]█#[fg=$TC,bold] #I:#W#F #[fg=$G06,bg=$BG,nobold]$right_arrow_icon"
tmux_set window-status-separator ""
tmux_set status-justify centre
tmux_set window-status-current-statys "fg=$TC,bg=$BG"
tmux_set pane-border-style "fg=$G07,bg=default"
tmux_set pane-active-border-style "fg=$TC,bg=$BG"
tmux_set display-panes-colour "$G07"
tmux_set display-panes-active-colour "$TC"
tmux_set clock-mode-colour "$TC"
tmux_set clock-mode-style 24
tmux_set message-style "fg=$TC,bg=$BG"
tmux_set message-command-style "fg=$TC,bg=$BG"
tmux_set mode-style "bg=$TC,fg=$FG"
