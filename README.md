# iOS-test-task

API Key: `fF7QkDcHYnH3Vihfm2Dckz4SuZz_v-XK`

API Endpoint URL: `https://eth-mainnet.g.alchemy.com/nft/v3/{apiKey}/getNFTsForOwner`

[getNFTsForOwner](https://docs.alchemy.com/reference/getnftsforowner-v3)

Owner ETH Address: `0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045`

1. Use the endpoint to fetch data: Initiate a network request to the provided API endpoint using URLSession. Implement error handling to manage any possible issues with the request
2. Display the NFTs: Create a list to display the NFTs owned by the specific ETH address. Each cell could show the NFT's name, image, and other relevant details
3. Implement refresh control: Include a pull-to-refresh functionality. This will allow users to manually update the list of NFTs
4. Detail View: When a user taps on an NFT, navigate to a detail view showing more information about the NFT
5. Search Functionality: Add a search bar to the screen that allows users to filter the displayed NFTs by name
6. Loading and Error States: Ensure to handle loading and error states. Show a loading spinner while the API request is in progress, and display an error message if the request fails
