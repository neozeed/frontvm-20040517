
#include <SDL/SDL_endian.h>
#include <SDL/SDL_mouse.h>

#include "main.h"
#include "decode.h"
#include "input.h"
#include "m68000.h"
#include "stMemory.h"
#include "hatari-glue.h"
#include "shortcut.h"

INPUT input;

void Call_GetMouseInput (unsigned long params)
{
	short *mouse_poop;
	/* Pointer passed to struct:
	 *   word mouse_motion_x
	 *   word mouse_motion_y
	 *   word mouse_buttons
	 */

	mouse_poop = (short*)(STRam + STMemory_ReadLong (params+SIZE_WORD));

	mouse_poop[0] = SDL_SwapBE16 (SDL_SwapBE16 (mouse_poop[0]) + input.motion_x);
	mouse_poop[1] = SDL_SwapBE16 (SDL_SwapBE16 (mouse_poop[1]) + input.motion_y);
	
	if (input.mbuf_head != input.mbuf_tail) {
		mouse_poop[2] = SDL_SwapBE16 (0xf8 | input.mousebut_buf [input.mbuf_head++]);
		input.mbuf_head %= SIZE_KEYBUF;
	} else {
		mouse_poop[2] = SDL_SwapBE16 (0xf8 | input.cur_mousebut_state);
	}
	
	input.motion_x = input.motion_y = 0;
}

void Call_GetKeyboardEvent (unsigned long params)
{
	if ((input.buf_head) != (input.buf_tail)) {
		Regs[REG_D0] = input.key_buf [input.buf_head++];
		input.buf_head %= SIZE_KEYBUF;
	} else {
		Regs[REG_D0] = 0;
	}
}




/* Interrupt as required */
void Input_Update ()
{
	if ((input.buf_head != input.buf_tail) ||
	    (input.motion_x) ||
	    (input.motion_y) ||
	    (input.mbuf_head != input.mbuf_tail)) {
		MakeSR ();
		
		if ((5 > FIND_IPL) && (5 > intlev ())) {
			ExceptionVector = EXCEPTION_INPUT;
			M68000_Exception ();
		}
	}
}

void Input_PressSTKey (unsigned char ScanCode, BOOL bPress)
{
	if (!bPress) ScanCode |= 0x80;
	input.key_buf [input.buf_tail++] = ScanCode;
	input.buf_tail %= SIZE_KEYBUF;
}

void Input_MousePress (int button)
{
	if (button == SDL_BUTTON_RIGHT) input.cur_mousebut_state |= 0x1;
	else if (button == SDL_BUTTON_LEFT) input.cur_mousebut_state |= 0x2;
	else if (button == SDL_BUTTON_MIDDLE) {
		/* middle mouse button toggles mouse grab */
		ShortCut_MouseMode();
		return;
	} else {
		return;
	}
	input.mousebut_buf [input.mbuf_tail++] = input.cur_mousebut_state;
	input.mbuf_tail %= SIZE_MOUSEBUF;
}

void Input_MouseRelease (int button)
{
	if (button == SDL_BUTTON_RIGHT) input.cur_mousebut_state &= ~0x1;
	else if (button == SDL_BUTTON_LEFT) input.cur_mousebut_state &= ~0x2;
	else return;
	input.mousebut_buf [input.mbuf_tail++] = input.cur_mousebut_state;
	input.mbuf_tail %= SIZE_MOUSEBUF;
}

