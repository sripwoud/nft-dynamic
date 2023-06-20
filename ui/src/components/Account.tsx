'use client'

import { useAccount, useEnsName } from 'wagmi'

export function Account() {
  const { address } = useAccount()
  const { data: ensName } = useEnsName({ address })

  return (
    <div>
      {ensName ?? address}
      {address !== undefined ? ` (${address})` : null}
    </div>
  )
}
