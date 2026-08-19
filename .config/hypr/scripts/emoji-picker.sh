#!/usr/bin/env bash

# Rofi-based fast Emoji Picker
EMOJI_FILE="$HOME/.config/hypr/scripts/emojis.txt"

if [[ ! -f "$EMOJI_FILE" ]]; then
    cat << 'EOF' > "$EMOJI_FILE"
😀 smile grinning
😃 smile happy
😄 smile joy
😁 beam grin
😆 squint laugh
😅 sweat smile
🤣 rofl laughing
😂 tears joy
🙂 slight smile
🙃 upside down
😉 wink
😊 blush smile
😇 innocent angel
🥰 smiling hearts love
😍 heart eyes love
🤩 star struck
😘 kiss blow
😗 kiss
😚 kissing closed eyes
😙 kiss smiling
😋 yum delicious
😛 tongue out
😜 tongue wink
🤪 zany goofy
😝 squint tongue
🤑 money mouth
🤗 hug smiling
🤭 hand over mouth
🤫 shush quiet
🤔 thinking ponder
🤐 zipper mouth
🤨 raised eyebrow
😐 neutral
😑 expressionless
😶 without mouth
😏 smirk
😒 unamused
🙄 roll eyes
😬 grimace
🤥 lying pinocchio
😌 relieved
😔 pensive sad
😪 sleepy tear
🤤 drooling
😴 sleeping
😷 mask sick
🤒 thermometer sick
🤕 head bandage
🤢 nauseated vomit
🤮 vomiting
🤧 sneezing
🥵 hot heat
🥶 cold freezing
🥴 woozy drunk
😵 dizzy
🤯 exploding head mind blown
🤠 cowboy hat
🥳 partying celebrate
😎 sunglasses cool
🤓 nerd geek
🧐 monocle classy
😕 confused
😟 worried
🙁 slight frown
😮 open mouth
😲 astonished
😳 flushed embarrassed
🥺 pleading puppy eyes
😦 frown open mouth
😧 anguished
😨 fearful
😰 anxious sweat
😥 sad relieved
😢 crying tear
😭 loudly crying sob
😱 scream fear
😖 confounded
😣 persevering
😞 disappointed
😓 downcast sweat
😩 weary
😫 tired
🥱 yawning
😤 triumph steam
😡 rage pouting
😠 angry
🤬 cursing swear
😈 smiling devil
👿 angry devil
💀 skull dead
☠️ skull crossbones
💩 poop
🤡 clown
👻 ghost
👽 alien
👾 monster alien
🤖 robot
🎃 pumpkin jack o lantern
😺 grinning cat
😸 grinning cat smile
😹 tears joy cat
😻 heart eyes cat
😼 smirk cat
😽 kiss cat
🙀 scream cat
😿 crying cat
😾 pouting cat
❤️ red heart
🧡 orange heart
💛 yellow heart
💚 green heart
💙 blue heart
💜 purple heart
🖤 black heart
🤍 white heart
🤎 brown heart
💔 broken heart
❣️ heart exclamation
💕 two hearts
💞 revolving hearts
💓 beating heart
💗 growing heart
💖 sparkling heart
💘 cupid arrow heart
💝 ribbon heart
🔥 fire flame lit
⭐ star
🌟 glowing star
✨ sparkles shiny
⚡ high voltage lightning
💥 collision explosion
💯 hundred points
🎉 party popper
🎊 confetti ball
🎁 wrapped gift
🏆 trophy winner
🥇 1st place medal
🥈 2nd place medal
🥉 3rd place medal
🎯 direct hit target
🚀 rocket launch
💡 light bulb idea
💻 laptop computer
📱 mobile phone
🎧 headphones music
🎵 musical note
🎶 musical notes
🎮 video game
🕹️ joystick game
☕ hot beverage coffee
🍺 beer mug
🥂 clinking glasses
🍕 pizza
🍔 hamburger
🍟 french fries
🍣 sushi
🍩 doughnut
🍰 shortcake
🍓 strawberry
🍎 red apple
🥑 avocado
🌮 taco
🍿 popcorn
👍 thumbs up like
👎 thumbs down dislike
👏 clapping hands
🙌 raising hands
🤝 handshake
🙏 folded hands pray please
✌️ victory peace
🤞 crossed fingers luck
🤘 rock on
🤙 call me hand
👈 point left
👉 point right
👆 point up
👇 point down
☝️ index point up
👋 waving hand bye
✋ raised hand
🤚 raised back of hand
🖐️ hand fingers splayed
💪 flexed biceps strong
👀 eyes look
🧠 brain smart
EOF
fi

chosen=$(cat "$EMOJI_FILE" | rofi -dmenu -i -p "😀 Emoji" -theme-str 'window { width: 450px; height: 420px; } listview { lines: 9; }')

[[ -z "$chosen" ]] && exit 0

emoji=$(echo "$chosen" | awk '{print $1}')

# Copy to clipboard
echo -n "$emoji" | wl-copy

# Type it automatically if wtype or ydotool is available
if command -v wtype >/dev/null 2>&1; then
    wtype "$emoji"
fi

notify-send "Emoji copié !" "$emoji  dans le presse-papiers" -t 1500
