# Polymarket Bot Setup Progress

## Status: PAUSED - Continue Later

### Completed Steps ✅
- **Step 1-3**: OpenClaw 설치, Telegram 봇 연동 완료

### In Progress ⏸️
- **Step 4**: Simmer Trading Platform 연결
  - **Agent Wallet Address**: `0x1C75f2b841Df7e661e16a003f6Ea1916aB0DdBb1`
  - **Required Funds**:
    - USDC.e (Polygon): $20-30
    - POL (Polygon): 5-10개
  - **Issue**: 업비트는 Polygon 미지원 → 바이낸스 사용 필요

### Next Steps (To Do) 📋
- **Step 5**: Trading Skills 설치
  - Command: `clawhub install polymarket-fast-loop`
  
- **Step 6**: Trading Rules 설정
  - 5-minute BTC trading 설정
  - 전략: Price deviation arbitrage
  - 진입: 0.5%+ 이동
  - 포지션 크기: $5
  - 최대 포지션: 3
  - 손절: -$3 per trade
  - 일일 한도: -$50

### Resources
- **Guide Source**: X Post by @LunarResearcher
- **Guide URL**: https://x.com/LunarResearcher/status/2023378639870455860
- **Simmer Markets**: https://simmer.markets/

### Notes
- 소액($20-30)으로 테스트 시작
- Polygon 네트워크 필수 (Ethereum/Solana 아님)
- 고위험 트레이딩 - 손실 가능성 있음
