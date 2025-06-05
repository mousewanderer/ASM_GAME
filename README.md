### ASM_GAME


# Introduction:

Gambling Dice is a text-based betting game developed in x86 Assembly language, playable via an emulator like EMU8086. The game allows players to bet on a number from 1 to 6, then simulates a dice roll to determine if they win or lose. The goal is to manage and grow your virtual money through luck and calculated risk. The Gambling Dice project was developed in x86 Assembly primarily for educational and technical demonstration purposes. And it aligns with the retro computing aesthetic, as text-based games were commonly written in low-level languages during the early days of DOS-based systems.
# Game features
• Betting System: Player starts with a virtual bankroll of $1000.
• Random Dice Generator: Uses system time to simulate dice rolls.
• Win/Lose Conditions: Based on player guess versus random roll.
• Dynamic Visual Feedback: Colored screen segments show win/lose outcomes.
• Multiple Rounds: Game continues until the player quits or runs out of money.
• ASCII-Based Dice Animations: Includes special visual effects when rolling
dice.
• Money Tracking: Adjusts user balance based on wins and losses.
• Platform used: EMU8086
# User Interface (UI) DESIGN)
it contains Both terminal-based for the text and pixel graphics for animation style.
Enter the amount to bet:
![Screenshot 2025-05-22 172801](https://github.com/user-attachments/assets/cbfed153-6120-4e9e-8997-009812d0bab3)

![Screenshot 2025-05-22 174109](https://github.com/user-attachments/assets/72d395ce-4672-4011-a431-109563794a94)

![Screenshot 2025-05-22 175802](https://github.com/user-attachments/assets/d67495d6-fe2d-4c64-a54d-624ce6580254)

![Screenshot 2025-05-22 175435](https://github.com/user-attachments/assets/c57a6ed7-d5f5-48d5-a0f5-68fb3c353339)

![Screenshot 2025-05-22 180959](https://github.com/user-attachments/assets/2c6c7a12-9071-4d53-9518-da01a9a5da63)


Controls List input methods:
Click any number that is a valid number for betting which must be lesser or equal to
than the current money that you must bet with. Then after that pick any number from 1
to 6 to select your bet then wait for the result. And for 0 if the user wants to exit. After
the result type any key to continue the game.

# Flowchart on the code

![79948e27-fd92-4b7d-a4bb-fa065320c725](https://github.com/user-attachments/assets/daeece4f-728d-4246-8d4e-6c67051b7f82)


# Challenges & Solutions
Technical Hurdles
1. Challenge: Generating random numbers in Assembly (no built-in RNG) while
ensuring fairness.

Solution: Used the system clock’s low-level ticks (via INT 1Ah) to seed a pseudo-
random algorithm, combined with modular arithmetic to limit outputs to 1–6.

2. Challenge: Limited registers (AX, BX, etc.) to track bets, balance, and dice
results simultaneously.
Solution: Reserved memory addresses using .data directives to persist data and
minimize register dependency.

3. Challenge: Creating smooth dice-roll animations without hardware-level timing
control or slow process to happen.
Solution: Implemented a loop-based delay for the animation and taking advance
of the terminal for the text to be printed in the system to achieve less time delay.
Conclusion: Lessons Learned
Low-Level Constraints: Working with Assembly reinforced the importance of manual
memory/register management and optimization.
Debugging Rigor: Even minor errors (e.g., incorrect CMP operands) caused crashes,
emphasizing the need for systematic testing.
Creative Problem-Solving: Simplified RNG and animations demonstrated how hardware
limitations can drive innovative solutions.
Future Enhancements
Expanded Gameplay:
Instead of the one kind of gameplay it can be scaled into a full-time casino game which
includes games like blackjack, Big Six-wheel, Roulette, Snake Eyes, etc.

# Visual Upgrades:

Printing the win/lose text after the visual effects have been displayed. And add things
like Colorized text to indicate low amount of money or selection screen if it supports
more than 1 kind of casino game.
Additional animations for enter, exit and lose scenes.
Code Optimization:
Refactor redundant logic into macros/subroutines especially the last part of the code
which consist of animations.

8. References: Tutorials, books, or example code used.

For the dice logic: 
https://realpython.com/python-dice-roll/

Betting system:
https://gist.github.com/zemmyang/8da1b85acd64f483d1c82a4725e004c0
