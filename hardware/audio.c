/*
  Hatari - audio.c

  This file is distributed under the GNU Public License, version 2 or at
  your option any later version. Read the file gpl.txt for details.

  This file contains the routines which pass the audio data to the SDL library.
*/

#include <SDL.h>

#include "main.h"
#include "audio.h"
#include "configuration.h"
#include "memAlloc.h"
#include "misc.h"
#include "decode.h"

#define SND_FREQ	22050

/* Converted frontier SFX to wav samples. */
#define MAX_SAMPLES	33
#define MAX_CHANNELS	4

typedef struct wav_stream {
	Uint8 *buf;
	int buf_pos;
	int buf_len;
	int loop; /* -1 no loop, otherwise specifies loop start pos */
} wav_stream;

wav_stream sfx_buf[MAX_SAMPLES];
wav_stream wav_channels[MAX_CHANNELS];

void Call_PlaySFX (unsigned long params)
{
	int sample, chan;

	SDL_LockAudio ();
	
	sample = Regs[REG_D0] & 0xffff;
	chan = Regs[REG_D1] & 0xffff;
	//printf ("Playing sample %d on channel %d.\n", sample, chan);

	wav_channels[chan].buf_pos = 0;
	wav_channels[chan].buf_len = sfx_buf[sample].buf_len;
	wav_channels[chan].buf = sfx_buf[sample].buf;
	wav_channels[chan].loop = sfx_buf[sample].loop;

	SDL_UnlockAudio ();
}

void Audio_Reset ()
{
	int i;
	SDL_LockAudio ();
	for (i=0; i<MAX_CHANNELS; i++) {
		wav_channels[i].buf = NULL;
	}
	SDL_UnlockAudio ();
}

/* 11Khz, 22Khz, 44Khz playback */
int SoundPlayBackFrequencies[] =
{
  11025,  /* PLAYBACK_LOW */
  22050,  /* PLAYBACK_MEDIUM */
  44100,  /* PLAYBACK_HIGH */
};


BOOL bDisableSound = FALSE;
BOOL bSoundWorking = TRUE;                /* Is sound OK */
volatile BOOL bPlayingBuffer = FALSE;     /* Is playing buffer? */
int OutputAudioFreqIndex = FREQ_22Khz;    /* Playback rate (11Khz,22Khz or 44Khz) */
float PlayVolume = 0.0f;
int SoundBufferSize = 1024;               /* Size of sound buffer */
int CompleteSndBufIdx;                    /* Replay-index into MixBuffer */



/*-----------------------------------------------------------------------*/
/*
  SDL audio callback function - copy emulation sound to audio system.
*/
void Audio_CallBack(void *userdata, Uint8 *pDestBuffer, int len)
{
	Sint8 *pBuffer;
	int i, j;
	short sample;
	BOOL playing = FALSE;
	
	pBuffer = pDestBuffer;
	
	for (i=0; i<MAX_CHANNELS; i++) {
		if (wav_channels[i].buf != NULL) {
			playing = TRUE;
			break;
		}
	}

	if (!playing) {
		memset (pDestBuffer, 0, len);
		return;
	}
	
	for (i = 0; i < len; i+=2) {
		sample = 0;
		for (j=0; j<MAX_CHANNELS; j++) {
			if (wav_channels[j].buf == NULL) continue;
			sample += *(short *)(wav_channels[j].buf + wav_channels[j].buf_pos);
			wav_channels[j].buf_pos += 2;
			if (wav_channels[j].buf_pos >= wav_channels[j].buf_len) {
				/* end of sample. either loop or terminate */
				if (wav_channels[j].loop != -1) {
					wav_channels[j].buf_pos = wav_channels[j].loop;
				} else {
					wav_channels[j].buf = NULL;
				}
			}
		}
		*((short*)pBuffer) = sample;
		pBuffer += 2;
	}
}

/*
 * Loaded samples must be SND_FREQ, 16-bit signed. Reject
 * other frequencies but convert 8-bit unsigned.
 */
void check_sample_format (SDL_AudioSpec *spec, Uint8 **buf, int *len, const char *filename)
{
	Uint8 *old_buf = *buf;
	short *new_buf;
	int i;

	if (spec->freq != SND_FREQ) {
		printf ("Sample %s is the wrong sample rate (wanted %dHz). Ignoring.\n", filename, SND_FREQ);
		SDL_FreeWAV (*buf);
		*buf = NULL;
		return;
	}

	if (spec->format == AUDIO_U8) {
		new_buf = malloc ((*len)*2);
		for (i=0; i<(*len); i++) {
			new_buf[i] = (old_buf[i] ^ 128) << 8;
		}
		*len *= 2;
		SDL_FreeWAV (old_buf);
		*buf = (char *)new_buf;
	} else if (spec->format != AUDIO_S16) {
		printf ("Sample %s is not 16-bit-signed or 8-bit unsigned. Ignoring.", filename);
		SDL_FreeWAV (*buf);
		*buf = NULL;
		return;
	}
}

/*-----------------------------------------------------------------------*/
/*
  Initialize the audio subsystem. Return TRUE if all OK.
  We use direct access to the sound buffer, set to a unsigned 8-bit mono stream.
*/
void Audio_Init(void)
{
	int i;
	char filename[32];
  SDL_AudioSpec desiredAudioSpec;    /* We fill in the desired SDL audio options here */

  /* Is enabled? */
  if(bDisableSound)
  {
    /* Stop any sound access */
    printf("Sound: Disabled\n");
    bSoundWorking = FALSE;
    return;
  }

  /* Init the SDL's audio subsystem: */
  if( SDL_WasInit(SDL_INIT_AUDIO)==0 )
  {
    if( SDL_InitSubSystem(SDL_INIT_AUDIO)<0 )
    {
      fprintf(stderr, "Could not init audio: %s\n", SDL_GetError() );
      bSoundWorking = FALSE;
      return;
    }
  }

  /* Set up SDL audio: */
  desiredAudioSpec.freq = SND_FREQ;
  desiredAudioSpec.format = AUDIO_S16;           /* 8 Bit unsigned */
  desiredAudioSpec.channels = 1;                /* Mono */
  desiredAudioSpec.samples = 1024;              /* Buffer size */
  desiredAudioSpec.callback = Audio_CallBack;
  desiredAudioSpec.userdata = NULL;

  if( SDL_OpenAudio(&desiredAudioSpec, NULL) )  /* Open audio device */
  {
    fprintf(stderr, "Can't use audio: %s\n", SDL_GetError());
    bSoundWorking = FALSE;
    ConfigureParams.Sound.bEnableSound = FALSE;
    return;
  }

  SoundBufferSize = desiredAudioSpec.size;      /* May be different than the requested one! */

  for (i=0; i<MAX_SAMPLES; i++) {
	  snprintf (filename, sizeof (filename), "sfx/sfx_%02d.wav", i);
	  if (SDL_LoadWAV (filename, &desiredAudioSpec, &sfx_buf[i].buf,
				  &sfx_buf[i].buf_len) == NULL) {
	  	printf ("Error loading %s: %s\n", filename, SDL_GetError ());
		sfx_buf[i].buf = NULL;
	  }
	  check_sample_format (&desiredAudioSpec, &sfx_buf[i].buf, &sfx_buf[i].buf_len, filename);
	  
	  /* 19 (hyperspace) and 23 (noise) loop */
	  if (i == 19) sfx_buf[i].loop = SND_FREQ; /* loop to about 0.5 sec in */
	  else if (i == 23) sfx_buf[i].loop = 0;
	  else sfx_buf[i].loop = -1;
  }
  
  /* All OK */
  bSoundWorking = TRUE;
  /* And begin */
  Audio_EnableAudio(TRUE);
}


/*-----------------------------------------------------------------------*/
/*
  Free audio subsystem
*/
void Audio_UnInit(void)
{
  /* Stop */
  Audio_EnableAudio(FALSE);

  SDL_CloseAudio();
}


/*-----------------------------------------------------------------------*/
/*
  Lock the audio sub system so that the callback function will not be called.
*/
void Audio_Lock(void)
{
  SDL_LockAudio();
}


/*-----------------------------------------------------------------------*/
/*
  Unlock the audio sub system so that the callback function will be called again.
*/
void Audio_Unlock(void)
{
  SDL_UnlockAudio();
}


/*-----------------------------------------------------------------------*/
/*
  Set audio playback frequency variable, pass as PLAYBACK_xxxx
*/
void Audio_SetOutputAudioFreq(int Frequency)
{
  /* Do not reset sound system if nothing has changed! */
  if(Frequency != OutputAudioFreqIndex)
  {
    /* Set new frequency, index into SoundPlayBackFrequencies[] */
    OutputAudioFreqIndex = Frequency;

    /* Re-open SDL audio interface... */
    Audio_UnInit();
    Audio_Init();
  }
}


/*-----------------------------------------------------------------------*/
/*
  Start/Stop sound buffer
*/
void Audio_EnableAudio(BOOL bEnable)
{
  if(bEnable && !bPlayingBuffer)
  {
    /* Start playing */
    SDL_PauseAudio(FALSE);
    bPlayingBuffer = TRUE;
  }
  else if(!bEnable && bPlayingBuffer)
  {
    /* Stop from playing */
    SDL_PauseAudio(!bEnable);
    bPlayingBuffer = bEnable;
  }
}


/*-----------------------------------------------------------------------*/
/*
  Scale sample value (-128...127) according to 'PlayVolume' setting
*/
Sint16 Audio_ModifyVolume(Sint16 Sample)
{
  /* If full volume, just use current value */
  if (PlayVolume==1.0f)
    return(Sample);

  /* Else, scale volume */
  Sample = (Sint16)((float)Sample*PlayVolume);

  return(Sample);
}

