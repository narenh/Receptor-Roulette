Receptor Roulette
=================

This is a minigame designed to illustrate the process of TCell selection performed by the human adaptive immune system.

More information can be found on the [project wiki](https://wiki.uchicago.edu/display/immunologygame/Receptor+Roulette) (regrettably private, at the moment). Discussion of the design and immunological basis for the minigame are located there. For an overview of the immunology behind this game, please see the [β-selection section](http://en.wikipedia.org/wiki/Thymocyte#.CE.B2-selection) of Wikipedia's article on Thymocytes.

Gameplay
--------

There is a massive "cell" at the right (or bottom) of the screen, rotating around. It represents an arbitrary professional antigen presenting cell (APC), with a bunch of antigens displayed on its surface.

As the APC spins around, TCells start spawning at the opposite end of the screen. The player must look at each TCell and determine whether it should be selected for in this β-selection process. The basics are this:

+ TCells without a yellow coreceptor should not be selected for.
+ TCells which are autoreactive (represented for now by being tinted orange) should not be selected for.
+ Other TCells should be matched to the corresponding receptor on the APC, based on the shape and color of the peptide.

When an autoreactive or nonfunctional TCell collides with the APC, it will lose the player points. So the player should double-tap the cell before that happens. This induces apoptosis, causing the cell to shrivel and disintegrate.

Structure
---------

The game mechanics are structured rather simply, with three important classes.

+	**MZNHTCellSprite:**
		Represents a TCell (thymocyte) in some state of functionality.
		Some TCells have no coreceptor, some react to the human-self peptide, and they all react to _some_ peptide.
+	**MZNHAPCReceptorSprite:**
		Represents an MHC displayed on the surface of the APC.
		The peptide displayed determines whether a given TCell reacts with it.
+	**MZNHRouletteLayer:**
		Manages the creation, movement, touching, dragging, matching, and removal of sprites and receptors.
		Most of the logic is here, with data in the previous two classes.
