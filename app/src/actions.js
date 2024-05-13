import { ethers } from 'ethers'
import EscrowList from './abi/EscrowList.json'

const contractAddress = process.env.REACT_APP_CONTRACT_ADDRESS || ''
 
export async function createEscrow (signer, mediater, beneficiary, value) {
  const factory = new ethers.Contract(contractAddress, EscrowList.abi, signer)
  return factory.newEscrow(mediater, beneficiary, { value })
}
  
export async function getListEscrows (signer) {
  const factory = new ethers.Contract(contractAddress, EscrowList.abi, signer)
  const list = await factory.getListEscrows()
  return list.map(item => ({
    ...item,
    amount: ethers.utils.formatEther(item.amount.toString())
  }))
}

export async function getListEscrowsToApprove (signer) {
  const factory = new ethers.Contract(contractAddress, EscrowList.abi, signer)
  const list = await factory.getListEscrowsToApprove()
  return list.map(item => ({
    ...item,
    amount: ethers.utils.formatEther(item.amount.toString())
  }))
}

export async function approveEscrow (signer, transaction) {
  const factory = new ethers.Contract(contractAddress, EscrowList.abi, signer)
  return factory.approveEscrow(transaction)
}



