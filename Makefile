# Makefile for Roblox API Dump utilities

API_DUMP = /Users/analog/Downloads/API-Dump.json
DOC_OUT = docs/ROBLOX_API_REFERENCE.md

.PHONY: docs test

docs:
	python generate_roblox_api_docs.py $(API_DUMP) $(DOC_OUT)

test:
	python test_roblox_api_dump.py
