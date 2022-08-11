function rr(){
    regions=(eu_west_1 eu_central_1 us_east_1)

    PS3='Select an region to work: '
	select opt in "${regions[@]}"; do
		case "$opt" in
        eu_west_1)
            export AWS_REGION='eu-west-1'
            break
			;;
        eu_central_1)
            export AWS_REGION='eu-central-1'
            break
			;;
        us_east_1)
            export AWS_REGION='us-east-1'
            break
			;;
        *)
			printf "Invalid selection. Please try again.\n"
			;;
        esac
	done
}