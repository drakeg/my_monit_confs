#!/bin/bash

CERT_FILE="/path/to/your/client_certificate.pem"
THRESHOLD_DAYS=14  # Two weeks threshold

# Get the certificate's expiration date
CERT_EXPIRATION_DATE=$(openssl x509 -in "$CERT_FILE" -noout -enddate | cut -d= -f 2)

# Convert the expiration date to a Unix timestamp
CERT_EXPIRATION_TIMESTAMP=$(date -d "$CERT_EXPIRATION_DATE" +%s)

# Get the current Unix timestamp
CURRENT_TIMESTAMP=$(date +%s)

# Calculate the difference in days
DAYS_LEFT=$(( ($CERT_EXPIRATION_TIMESTAMP - $CURRENT_TIMESTAMP) / 86400 ))

if [ "$DAYS_LEFT" -lt "$THRESHOLD_DAYS" ]; then
  echo "SSL client certificate will expire in $DAYS_LEFT days. Renew it."
  exit 1  # Exit with an error code to trigger Monit alert
else
  echo "SSL client certificate is still valid for $DAYS_LEFT days."
  exit 0  # Exit with a success code
fi
