.PHONY: default
default: setup

.PHONY: setup
setup:
	bin/setup

.PHONY: console
console:
	bin/console

.PHONY: spec
spec:
	bundle exec rspec

.PHONY: test
test: spec

.PHONY: report_coverage
report_coverage:
	bundle exec codeclimate-test-reporter

.PHONY: guard
guard:
	bundle exec guard

.PHONY: install
install:
	bundle exec rake install

.PHONY: release
release:
	bundle exec rake release
