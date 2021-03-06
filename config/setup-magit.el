;;
;; Magit
;;

;; shortcuts
(safe-fn-when magit-status
  (global-set-key (kbd "C-c g s") 'magit-status))
(safe-fn-when magit-pull
  (global-set-key (kbd "C-c g p") 'magit-pull))
(safe-fn-when magit-push
  (global-set-key (kbd "C-c g P") 'magit-push))
(safe-fn-when magit-log
  (global-set-key (kbd "C-c g l") 'magit-log))
(safe-fn-when magit-log-buffer-file
  (global-set-key (kbd "C-c g b") 'magit-log-buffer-file))
(safe-fn-when magit-checkout
  (global-set-key (kbd "C-c g c") 'magit-checkout))
(safe-fn-when magit-merge
  (global-set-key (kbd "C-c g m") 'magit-merge))

