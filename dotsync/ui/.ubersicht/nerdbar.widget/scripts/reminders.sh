#!/usr/bin/env bash

echo $(osascript -e "tell application \"Reminders\" to set reminderCount to count of (reminders in list \"GetUp2GetDown\" whose completed is false)")
