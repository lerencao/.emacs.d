;;;; -*- lexical-binding:t -*-
;;;;
;; strap
;;;;




(defun compile-and-load-elisp-files! (vdir &rest files)
  "Compile and load the elisp FILES, save compiled files in VDIR."
  (declare (indent 1))
  (dolist (f files)
    (compile-and-load-elisp-file* vdir f)))



;; Versioned dirs
(setq-default recentf-save-file (v-home! ".recentf/" "recentf"))
(setq-default savehist-file (v-home! ".minibuffer/" "history"))



(defmacro save-sexpr-to-file (sexpr file)
  "Save SEXPR to the FILE."
  `(save-excursion
     (let ((sexpr-buffer (find-file-noselect ,file)))
       (set-buffer sexpr-buffer)
       (erase-buffer)
       (print ,sexpr sexpr-buffer)
       (save-buffer)
       (kill-buffer sexpr-buffer))))


(defmacro theme-supported-p (&rest body)
  (declare (indent 1))
  `(graphic-supported-p
     (version-supported-when
         < 23
       ,@body)))


(defmacro font-supported-p (&rest body)
  (declare (indent 1))
  `(graphic-supported-p
     ,@body))


(defsubst self-def-files! ()
  "Returns the PATH of `self-path.el' and make self-*.el files."
  (let ((d (emacs-home* "private/"))
        (p (emacs-home* "private/self-path.el"))
        (fs `(,(cons (emacs-home* "private/self-path.el")
                     (emacs-home* "config/self-path.el"))
              ,(cons (emacs-home* "private/self-env-spec.el")
                     (emacs-home* "config/sample-self-env-spec.el"))
              ,(cons (emacs-home* "private/self-package-spec.el")
                     (emacs-home* "config/sample-self-package-spec.el"))
              ,(cons (emacs-home* "private/self-prelogue.el")
                     (emacs-home* "config/sample-self-prelogue.el"))
              ,(cons (emacs-home* "private/self-epilogue.el")
                     (emacs-home* "config/sample-self-epilogue.el")))))
    (when (not (file-exists-p p))
      (when (not (file-exists-p d)) (make-directory d t))
      (dolist (f fs)
        (let ((dst (car f))
              (src (cdr f)))
          (when (not (file-exists-p dst))
            (copy-file src dst t)))))
    p))


(defvar self-def-where (self-def-files!)
  "Where's the path of self-path.el")

(defvar self-def-paths nil
  "Default `self-def-path', override in `private/self-path.el'")


;; Load self where
(compile-and-load-elisp-files!
    v-dir
  self-def-where)


;; Load self env
(compile-and-load-elisp-files!
    v-dir
  (plist-get self-def-paths :env-spec))


;; Load ui, shell, basic env:
(compile-and-load-elisp-files!
    v-dir
  (emacs-home* "config/boot.el")
  (emacs-home* "config/shell.el")
  (emacs-home* "config/basic.el"))


;; Self do prelogue ...
(compile-and-load-elisp-files!
    v-dir
  (plist-get self-def-paths :prelogue))


(package-supported-p
  ;; (package-initialize)

  ;; Load basic and self modules
  (compile-and-load-elisp-files!
      v-dir
    (plist-get self-def-paths :package-spec)
    (emacs-home* "config/module.el")))


;; Load package independent modules
(compile-and-load-elisp-files!
    v-dir
  (emacs-home* "config/debugger.el")
  (emacs-home* "config/editing.el")
  (emacs-home* "config/financial.el")
  (emacs-home* "config/tags.el")
  (emacs-home* "config/utils.el")
  (emacs-home* "config/memory.el"))


;; Self do epilogue ...
(compile-and-load-elisp-files!
    v-dir
  (plist-get self-def-paths :epilogue))
