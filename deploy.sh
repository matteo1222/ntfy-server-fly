#!/bin/bash

# ntfy Server Deployment Script
# This script helps deploy your ntfy server to Fly.io

set -e

echo "🔔 ntfy Server Deployment Script"
echo "================================"

# Check if flyctl is installed
if ! command -v flyctl &> /dev/null; then
    echo "❌ flyctl is not installed. Please install it first:"
    echo "   curl -L https://fly.io/install.sh | sh"
    exit 1
fi

# Check if user is logged in
if ! flyctl auth whoami &> /dev/null; then
    echo "❌ You're not logged in to Fly.io. Please run:"
    echo "   flyctl auth login"
    exit 1
fi

# Read app name from fly.toml
APP_NAME=$(grep '^app = ' fly.toml | cut -d'"' -f2)

if [ "$APP_NAME" = "your-app-name-ntfy" ]; then
    echo "⚠️  Please update the app name in fly.toml before deploying!"
    echo "   Change 'your-app-name-ntfy' to your desired app name"
    exit 1
fi

echo "📱 App name: $APP_NAME"

# Check if app exists
if ! flyctl apps list | grep -q "$APP_NAME"; then
    echo "🆕 Creating new app: $APP_NAME"
    flyctl apps create "$APP_NAME"
else
    echo "✅ App $APP_NAME already exists"
fi

# Check if volume exists
if ! flyctl volumes list | grep -q "ntfy_data"; then
    echo "💾 Creating persistent volume..."
    flyctl volumes create ntfy_data --size 1 --region nrt
else
    echo "✅ Volume ntfy_data already exists"
fi

# Update base-url in server.yml
echo "🔧 Updating base-url in server.yml..."
sed -i.bak "s|base-url: \"https://.*\"|base-url: \"https://$APP_NAME.fly.dev\"|g" server.yml
rm server.yml.bak

# Deploy
echo "🚀 Deploying to Fly.io..."
flyctl deploy

# Health check
echo "🏥 Performing health check..."
sleep 10
if curl -f "https://$APP_NAME.fly.dev/v1/health" &> /dev/null; then
    echo "✅ Deployment successful!"
    echo "🌐 Your ntfy server is available at: https://$APP_NAME.fly.dev"
    echo ""
    echo "🧪 Test it with:"
    echo "   curl -d 'Hello from your ntfy server!' https://$APP_NAME.fly.dev/test"
else
    echo "❌ Health check failed. Check logs with:"
    echo "   flyctl logs"
    exit 1
fi

echo ""
echo "🎉 Deployment complete!"
echo "📖 Documentation: https://docs.ntfy.sh/"
echo "🔧 Manage your app: https://fly.io/apps/$APP_NAME"
