import { Account, Connect, Connected, Counter, NetworkSwitcher } from '~'

export default function Page() {
  return (
    <>
      <h1>wagmi + Next.js + Foundry</h1>

      <Connect />

      <Connected>
        <Account />
        <hr />
        <Counter />
        <hr />
        <NetworkSwitcher />
      </Connected>
    </>
  )
}
