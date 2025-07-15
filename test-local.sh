#!/bin/bash

# Local testing script for ntfy server
# This script helps test your ntfy server locally with Docker

set -e

echo "🧪 ntfy Server Local Testing"
echo "============================"

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Build the Docker image
echo "🔨 Building Docker image..."
docker build -t ntfy-server-test .

# Run the container
echo "🚀 Starting ntfy server locally..."
docker run -d \
    --name ntfy-server-test \
    -p 8080:80 \
    --rm \
    ntfy-server-test

echo "⏳ Waiting for server to start..."
sleep 5

# Test health endpoint
echo "🏥 Testing health endpoint..."
if curl -f http://localhost:8080/v1/health &> /dev/null; then
    echo "✅ Health check passed!"
else
    echo "❌ Health check failed!"
    docker logs ntfy-server-test
    docker stop ntfy-server-test
    exit 1
fi

# Test sending a message
echo "📨 Testing message sending..."
curl -d "Hello from local ntfy server!" http://localhost:8080/test-topic

echo ""
echo "✅ Local testing complete!"
echo "🌐 Your local ntfy server is running at: http://localhost:8080"
echo "📱 Test in another terminal:"
echo "   curl -s http://localhost:8080/test-topic/raw"
echo "   curl -d 'Test message' http://localhost:8080/test-topic"
echo ""
echo "🛑 To stop the server:"
echo "   docker stop ntfy-server-test"