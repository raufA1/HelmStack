🔹 2. hs komandaları (Makefile aliasları)

Əvvəlcə Makefile-in adını dəyişirik → Helmfile (sən make əvəzinə hs istifadə edə biləsən).

Sonra .bashrc və ya .zshrc-ə əlavə et:

alias hs="make -f Helmfile"

🔹 3. Əsas hs komandaları (aliaslı Makefile)
# Helmfile

.PHONY: start go fix work done save ask check yes no end build ideas setup status next focus log clean commit push

start:   ## 🚀 Full setup + init
	@bash scripts/start.sh

go:      ## 🔥 Alias for start
	@$(MAKE) start

fix:     ## 🛠 Refresh plan
	@bash scripts/fix.sh

work:    ## 💼 Focus mode
	@bash scripts/work.sh

done:    ## ✅ End of day wrap-up
	@bash scripts/done.sh

save:    ## 💾 Snapshot
	@bash scripts/save.sh

ask:     ## ❓ Start research
	@bash scripts/ask.sh

check:   ## 🔍 Review research
	@bash scripts/check.sh

yes:     ## 👍 Approve changes
	@bash scripts/yes.sh

no:      ## 👎 Request changes
	@bash scripts/no.sh

end:     ## 🏁 Close research
	@bash scripts/end.sh

build:   ## 🏗 Generate README/docs
	@bash scripts/build.sh

ideas:   ## 💡 Extract TODOs
	@bash scripts/ideas.sh

setup:   ## ⚙️ GitHub setup
	@bash scripts/setup.sh

status:  ## 📊 Current status
	@bash scripts/status.sh

next:    ## ⏭ Next steps
	@bash scripts/next.sh

focus:   ## 🎯 Today's focus
	@bash scripts/focus.sh

log:     ## 📖 Session log
	@bash scripts/log.sh

clean:   ## 🧹 Clean cache
	@bash scripts/clean.sh

commit:  ## 💾 Git commit
	git add -A && git commit -m "update"

push:    ## 🚀 Push to GitHub
	git push origin main

🔹 4. İstifadə nümunəsi
# Yeni layihə
mkdir tidytasks && cd tidytasks

# HelmStack quraşdır
hs start NAME="TidyTasks" DESC="Personal task manager" DOC=tidytasks.md

# Planı düzəlt
hs fix

# Fokus işlər
hs work

# Gün sonu
hs done

