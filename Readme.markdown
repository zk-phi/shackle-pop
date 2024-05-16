# shackle-pop

Make shackle.el behave more like popwin.el.

## Installation

Just load this package.

``` emacs-lisp
(require 'shackle-pop)
```

## Features / Configurations

All these features are enabled by default. If you want to disable some of them, set to `nil`.

- `shackle-pop-auto-close`

  When a window is popped up by a shackle, the window will be auto-closed after `keyboard-quit
  (C-g)` is pressed.

- `shackle-pop-auto-reuse`

  When a window is popped up by shackle, the window will be reused when another popup is requested.

- `shackle-pop-auto-align`

  When a window is popped up by shackle, the window is automatically aligned even if the rule does
  not contain `:align t`.

  You may override this behavior on a per-rule basis by adding `:align nil` to some rules.

  This feature exists just to clean-up `shackle-rule`.

  You may also want to set `shackle-default-alignment` and `shackle-default-size`.

## Sample configuration

``` emacs-lisp
(require 'shackle)
(require 'shackle-pop)

;; we don't need to specify (:align 'below :size 0.33) for each entries
(setq shackle-rules '(("*Help*"                 :select t   :popup t)
                      ("*info*"                 :select t   :popup t)
                      ("*Warnings*"             :select t   :popup t)
                      ("*Buffer List*"          :select t   :popup t)
                      ("*compilation*"          :select nil :popup t)
                      ("*Shell Command Output*" :select t   :popup t)
                      ;; when selected compilation may fail ?
                      ("*Compile-Log*"          :select nil :popup t)
                      ("*Backtrace*"            :select t   :popup t)
                      ("*Completions*"          :select nil :popup t))
      shackle-default-rule '(:same t)
      shackle-default-alignment 'below
      shackle-default-size 0.33)
```
