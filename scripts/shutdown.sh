#!/bin/bash

# Shutdown if no players connected (simple example)
if ! netstat -an | grep 25565 | grep ESTABLISHED; then
  echo "No players connected. Shutting down..."
  shutdown now
fi