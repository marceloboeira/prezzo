.PHONY: default
default: setup

.PHONY: setup
setup:
	bin/setup

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
