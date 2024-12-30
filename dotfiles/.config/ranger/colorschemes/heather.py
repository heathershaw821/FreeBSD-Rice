# This file is part of ranger, the console file manager.
# License: GNU GPL version 3, see the file "AUTHORS" for details.

from __future__ import (absolute_import, division, print_function)

from ranger.colorschemes.default import Default
from ranger.gui.color import *

import curses

class Scheme(Default):
		progress_bar_color = 115

		def use(self, context):
				fg, bg, attr = Default.use(self, context)
				
				if context.directory and not context.marked and not context.link \
								and not context.inactive_pane:
						fg = self.progress_bar_color
				elif context.image and not context.marked and not context.link \
							and not context.inactive_pane:
						fg = green

				elif context.in_titlebar and context.hostname:
						fg = red if context.bad else 121

				return fg, bg, attr
