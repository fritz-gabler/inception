#!/bin/bash   

mysqladmin ping -h localhost -p"$(cat run/secrets/sql-root-pass)"
