#include QMK_KEYBOARD_H
#include "version.h"
#include "keymap_german.h"
#include "keymap_nordic.h"
#include "keymap_french.h"
#include "keymap_spanish.h"
#include "keymap_hungarian.h"
#include "keymap_swedish.h"
#include "keymap_br_abnt2.h"
#include "keymap_canadian_multilingual.h"
#include "keymap_german_ch.h"
#include "keymap_jp.h"
#include "keymap_bepo.h"
#include "keymap_italian.h"
#include "keymap_slovenian.h"
#include "keymap_danish.h"
#include "keymap_norwegian.h"
#include "keymap_portuguese.h"
#include "keymap_contributions.h"
#include "keymap_czech.h"
#include "keymap_romanian.h"
#include "keymap_russian.h"
#include "keymap_uk.h"
#include "keymap_estonian.h"

#define KC_MAC_UNDO LGUI(KC_Z)
#define KC_MAC_CUT LGUI(KC_X)
#define KC_MAC_COPY LGUI(KC_C)
#define KC_MAC_PASTE LGUI(KC_V)
#define KC_PC_UNDO LCTL(KC_Z)
#define KC_PC_CUT LCTL(KC_X)
#define KC_PC_COPY LCTL(KC_C)
#define KC_PC_PASTE LCTL(KC_V)
#define ES_LESS_MAC KC_GRAVE
#define ES_GRTR_MAC LSFT(KC_GRAVE)
#define ES_BSLS_MAC ALGR(KC_6)
#define NO_PIPE_ALT KC_GRAVE
#define NO_BSLS_ALT KC_EQUAL
#define LSA_T(kc) MT(MOD_LSFT | MOD_LALT, kc)
#define BP_NDSH_MAC ALGR(KC_8)
#define MOON_LED_LEVEL LED_LEVEL

enum custom_keycodes {
  RGB_SLD = ML_SAFE_RANGE,
  HSV_0_255_255,
  HSV_86_255_128,
  ST_MACRO_0,
  ST_MACRO_1,
  ST_MACRO_2,
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [0] = LAYOUT_moonlander(
    KC_GRAVE,       KC_1,           KC_2,           KC_3,           KC_4,           KC_5,           KC_LPRN,                                        KC_RPRN,        KC_6,           KC_7,           KC_8,           KC_9,           KC_0,           KC_MINUS,       
    KC_TAB,         KC_Q,           KC_W,           KC_E,           KC_R,           KC_T,           KC_LBRACKET,                                    KC_RBRACKET,    KC_Y,           KC_U,           KC_I,           KC_O,           KC_P,           KC_BSLASH,      
    KC_BSPACE,      KC_A,           KC_S,           KC_D,           KC_F,           KC_G,           KC_COMMA,                                                                       KC_DOT,         KC_H,           KC_J,           KC_K,           KC_L,           LT(2,KC_SCOLON),LGUI_T(KC_QUOTE),
    KC_LSHIFT,      LCTL_T(KC_Z),   KC_X,           KC_C,           KC_V,           KC_B,                                           KC_N,           KC_M,           KC_COMMA,       KC_DOT,         RCTL_T(KC_SLASH),KC_RSHIFT,      
    KC_DELETE,      ST_MACRO_0,     ST_MACRO_1,     ST_MACRO_2,     OSL(1),         KC_LALT,                                                                                                        LCTL_T(KC_ESCAPE),KC_LEFT,        KC_UP,          KC_DOWN,        KC_RIGHT,       TT(2),          
    LCTL_T(KC_SPACE),KC_BSPACE,      KC_LGUI,                        KC_LALT,        KC_TAB,         KC_ENTER
  ),
  [1] = LAYOUT_moonlander(
    KC_ESCAPE,      KC_F1,          KC_F2,          KC_F3,          KC_F4,          KC_F5,          KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_F6,          KC_F7,          KC_F8,          KC_F9,          KC_F10,         KC_F11,         
    KC_TRANSPARENT, KC_EXLM,        KC_AT,          KC_LPRN,        KC_RPRN,        KC_PIPE,        KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_7,           KC_8,           KC_9,           KC_KP_PLUS,     KC_EQUAL,       KC_F12,         
    KC_BSPACE,      KC_HASH,        KC_DLR,         KC_LBRACKET,    KC_RBRACKET,    KC_GRAVE,       KC_TRANSPARENT,                                                                 KC_TRANSPARENT, KC_4,           KC_5,           KC_6,           KC_KP_MINUS,    KC_DOWN,        KC_TRANSPARENT, 
    KC_LSHIFT,      KC_PERC,        KC_CIRC,        KC_COMMA,       KC_DOT,         KC_TILD,                                        KC_1,           KC_2,           KC_3,           KC_KP_ASTERISK, KC_AMPR,        KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_COMMA,       HSV_0_255_255,  HSV_86_255_128, TO(0),          RGB_MOD,                                                                                                        RGB_TOG,        KC_0,           KC_DOT,         KC_KP_SLASH,    KC_0,           KC_TRANSPARENT, 
    LCTL_T(KC_SPACE),KC_BSPACE,      TOGGLE_LAYER_COLOR,                RGB_SLD,        RGB_HUD,        KC_ENTER
  ),
  [2] = LAYOUT_moonlander(
    AU_TOG,         RESET,          KC_TRANSPARENT, KC_TRANSPARENT, KC_MEDIA_PREV_TRACK,KC_MEDIA_NEXT_TRACK,KC_MEDIA_PLAY_PAUSE,                                KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    MU_TOG,         KC_TRANSPARENT, KC_MS_UP,       KC_TRANSPARENT, KC_AUDIO_VOL_UP,KC_AUDIO_VOL_DOWN,KC_AUDIO_MUTE,                                  KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    MU_MOD,         KC_MS_LEFT,     KC_MS_DOWN,     KC_MS_RIGHT,    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_PSCREEN,                                     KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, 
    TO(0),          WEBUSB_PAIR,    KC_TRANSPARENT, KC_MS_BTN1,     KC_MS_BTN2,     KC_TRANSPARENT,                                                                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, TO(0),          
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                 KC_TRANSPARENT, KC_TRANSPARENT, KC_WWW_BACK
  ),
};

extern bool g_suspend_state;
extern rgb_config_t rgb_matrix_config;

void keyboard_post_init_user(void) {
  rgb_matrix_enable();
}

const uint8_t PROGMEM ledmap[][DRIVER_LED_TOTAL][3] = {
    [0] = { {239,123,213}, {134,255,213}, {10,225,255}, {141,255,233}, {239,123,213}, {239,123,213}, {239,123,213}, {85,203,158}, {180,255,233}, {14,255,255}, {239,123,213}, {85,203,158}, {134,255,213}, {239,123,213}, {141,255,233}, {239,123,213}, {239,123,213}, {10,225,255}, {239,123,213}, {0,204,255}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213}, {32,255,234}, {12,225,241}, {0,204,255}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213}, {250,159,255}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213}, {154,255,255}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213}, {35,255,255}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213}, {249,228,255}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213}, {105,255,255}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213}, {169,120,255}, {146,224,255}, {146,224,255}, {239,123,213}, {239,123,213}, {239,123,213}, {239,123,213} },

    [1] = { {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {14,255,255}, {14,255,255}, {14,255,255}, {154,181,198}, {154,181,198}, {33,255,255}, {33,255,255}, {33,255,255}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {0,204,255}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {85,203,158}, {32,176,255}, {134,255,213}, {243,222,234}, {154,181,198}, {14,255,255}, {14,255,255}, {14,255,255}, {141,255,233}, {154,181,198}, {14,255,255}, {14,255,255}, {14,255,255}, {0,0,255}, {154,181,198}, {14,255,255}, {14,255,255}, {14,255,255}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198}, {154,181,198} },

    [2] = { {154,86,255}, {252,119,255}, {195,61,255}, {0,0,0}, {31,255,255}, {0,183,238}, {0,0,0}, {32,176,255}, {0,0,0}, {0,0,255}, {0,0,0}, {10,225,255}, {243,222,234}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {85,203,158}, {0,0,0}, {250,159,255}, {31,255,255}, {14,255,255}, {0,0,0}, {0,0,0}, {254,198,190}, {0,183,238}, {30,96,255}, {0,0,0}, {85,203,158}, {141,255,233}, {0,0,255}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {31,255,255}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0} },

};

void set_layer_color(int layer) {
  for (int i = 0; i < DRIVER_LED_TOTAL; i++) {
    HSV hsv = {
      .h = pgm_read_byte(&ledmap[layer][i][0]),
      .s = pgm_read_byte(&ledmap[layer][i][1]),
      .v = pgm_read_byte(&ledmap[layer][i][2]),
    };
    if (!hsv.h && !hsv.s && !hsv.v) {
        rgb_matrix_set_color( i, 0, 0, 0 );
    } else {
        RGB rgb = hsv_to_rgb( hsv );
        float f = (float)rgb_matrix_config.hsv.v / UINT8_MAX;
        rgb_matrix_set_color( i, f * rgb.r, f * rgb.g, f * rgb.b );
    }
  }
}

void rgb_matrix_indicators_user(void) {
  if (g_suspend_state || keyboard_config.disable_layer_led) { return; }
  switch (biton32(layer_state)) {
    case 0:
      set_layer_color(0);
      break;
    case 1:
      set_layer_color(1);
      break;
    case 2:
      set_layer_color(2);
      break;
   default:
    if (rgb_matrix_get_flags() == LED_FLAG_NONE)
      rgb_matrix_set_color_all(0, 0, 0);
    break;
  }
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
    case ST_MACRO_0:
    if (record->event.pressed) {
      SEND_STRING(SS_LALT(SS_TAP(X_ENTER)));

    }
    break;
    case ST_MACRO_1:
    if (record->event.pressed) {
      SEND_STRING(SS_LCTL(SS_TAP(X_L)));

    }
    break;
    case ST_MACRO_2:
    if (record->event.pressed) {
      SEND_STRING(SS_LSFT(SS_TAP(X_F6)));

    }
    break;
    case RGB_SLD:
      if (record->event.pressed) {
        rgblight_mode(1);
      }
      return false;
    case HSV_0_255_255:
      if (record->event.pressed) {
        rgblight_mode(1);
        rgblight_sethsv(0,255,255);
      }
      return false;
    case HSV_86_255_128:
      if (record->event.pressed) {
        rgblight_mode(1);
        rgblight_sethsv(86,255,128);
      }
      return false;
  }
  return true;
}
