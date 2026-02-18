#!/bin/bash
# Fetch RSS feeds for morning brief (macOS compatible)
# Added more sources based on recommendations

echo "=== Morning Brief RSS Fetch ==="
echo "Date: $(date '+%Y-%m-%d %H:%M')"
echo ""

# Fetch 연합뉴스 IT
echo "📰 연합뉴스 IT/과학"
curl -s "https://www.yna.co.kr/rss/it-science.xml" | sed -n 's/.*<title>\([^<]*\)<\/title>.*/\1/p' | tail -n +2 | head -3
echo ""

# Fetch TechCrunch
echo "📰 TechCrunch"
curl -s "https://techcrunch.com/feed/" | sed -n 's/.*<title>\([^<]*\)<\/title>.*/\1/p' | tail -n +2 | head -3
echo ""

# Fetch Reddit r/technology
echo "📰 Reddit r/technology"
curl -s "https://www.reddit.com/r/technology/.rss" | sed -n 's/.*<title>\([^<]*\)<\/title>.*/\1/p' | tail -n +2 | head -3
echo ""

# Fetch Hacker News
echo "📰 Hacker News"
curl -s "https://news.ycombinator.com/rss" | sed -n 's/.*<title>\([^<]*\)<\/title>.*/\1/p' | tail -n +2 | head -3
echo ""

# Fetch Dev.to
echo "📰 Dev.to"
curl -s "https://dev.to/feed" | sed -n 's/.*<title>\([^<]*\)<\/title>.*/\1/p' | tail -n +2 | head -3
echo ""

echo "=== End of RSS Fetch ==="
