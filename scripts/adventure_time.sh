#!/bin/bash
 
# Objective: Create your own text-based "Create Your Own Adventure story" using Bash scripting. 
# Apply knowledge of loops and conditionals to make the story interactive, 
# Allow the player to make choices that affect the outcome.
#Adventure Time 

 
 
# The Story begins...
echo
echo "............................................................ "
echo "Welcome to 'A Date Gone Wrong' - Your choice, Your Story!"
echo "............................................................"
echo " "
echo " After so many left swipes, you've got a date!"
echo " "
echo " You've been looking forward to this date for weeks...But, as you arrive at the restaurant..."
echo " "
echo " "
 
 
 
# User makes the First choice
echo "1. You realize you forgot your wallet (Oh shucks!)"
echo "2. You notice your date texting someone else (What in the blazes!?! ... but hey, let's play it cool)"
echo " "
read -p " What do you pick?  Option 1 or 2.... " first_choice
echo  
echo

 
if [ "$first_choice" == "1" ]; then
    echo "So, You've forgotten your wallet. What do you do?"
    echo " "
    echo  "1. Be honest and explain the situation to your date (At least you won't have to wash dishes at the end of the dinner to cover your portion.) "
    echo "2. Pretend everything is fine and hope your date will pay (Bad idea but hey, that's on you!) "
    echo " "
    echo " "
    read -p " Would you be honest (Pick 1) or Pretend (Pick 2)..... " first_choice_pick
    echo
    echo




# User makes the next choice

    if [ "$first_choice_pick" == "1" ]; then
        echo "Your honesty is appreciated. Your date offers to split the bill using venmo. (Whew, crisis averted!) "
        echo "The evening continues pleasantly, and you both laugh about the incident.( Hnmm, they might be a keeper!)"
        echo " "
        echo "Congratulations! Despite the hiccup, your date was a success!"
        echo "(P.S: You are lucky you did not end up washing dishes to cover your portion of the bill!)"

    elif [ "$first_choice_pick" == "2" ]; then
        echo "You try to act normal, but when the bill arrives, your date notices your discomfort."
        echo "They're upset by your dishonesty, and the date ends awkwardly.(Well ... like we did not see that coming. )"
        echo " "
        echo "Game Over, greedy bugger! You probably should have come clean before you wolfed down the meal!"


# If user picks the wrong option
    else 
        echo " Invalid option. Try again. Next time, Please pick from your given choices"
    fi




# if User Picks the second option       
elif [ "$first_choice" == "2" ]; then  
    echo "You see your date texting someone else. How do you react?"
    echo " "
    echo "1. Confront them about it ( Why do you have to be so extra? For crying out loud it's just the first date!)"
    echo "2. Ignore it and try to engage them in conversation (You might as well enjoy the evening right?)"
    echo " "
    echo " "
    read -p " Do you Confront then (Pick 1) or Ignore it (Pick 2)" second_choice_pick



    if [ "$second_choice_pick" == "1" ]; then
        echo "You respectfully ask about the texting. Your date apologizes, explaining it was a work emergency.(Being Understanding is one of your strongest traits)"
        echo "They put their phone away, and you have a great conversation for the rest of the evening."
        echo " "
        echo " See, there was no need to be extra! Congratulations, your communication skills saved the date!"
    
    elif [ "$second_choice_pick" == "2" ]; then
        echo "You try to ignore the texting, but your date remains distracted throughout dinner. (Well, this is awkward...)"
        echo "The evening drags on uncomfortably, and you both leave feeling disappointed.(Bummer! Such a sad waste of a nice outfit and good perfume.) "
        echo 
        echo
        echo
        echo " Well, I guess it pays to address issues directly. On the bright side, at least you dodged a bullet!"

# If user picks the wrong option
    else 
        echo " Invalid Option. Try again. Next time, please pick from your given choices"

    fi
fi

echo
echo "..........................................................................................................."
echo "Thanks for playing 'A Date Gone Wrong'!"
echo  
echo "Hope this ridiculous adventure  made you smile, cackle or Guffaw( Yup! it's a real word, please look it up)"
echo " .........................................................................................................."
