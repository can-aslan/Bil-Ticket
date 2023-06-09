import { Center, SelectItem, Tabs } from '@mantine/core';
import { notifications } from '@mantine/notifications';
import { IconBuilding, IconBus, IconPlane } from '@tabler/icons-react';
import { useState } from 'react';
import ItemsNotFoundPage from '../../components/common/feedback/ItemsNotFoundPage';
import BusTab from '../../components/fare/bus/BusTab';
import PlaneTab from '../../components/fare/plane/PlaneTab';
import HotelTab from '../../components/hotel/HotelTab';
import useAxiosSecure from '../../hooks/auth/useAxiosSecure';
import useBusFares from '../../hooks/fare/useBusFares';
import useFlightFares from '../../hooks/fare/useFlightFares';
import useGetStations from '../../hooks/location/useGetStations';
import { FareSearchParams } from '../../types';
import { Station } from '../../types/LocationTypes';
import { isErrorResponse } from '../../utils/utils';
import LoadingPage from '../LoadingPage';

const SearchFarePage = () => {
	const axiosSecure = useAxiosSecure();
	const {
		data: allStations,
		isLoading: isStationsLoading,
		isError: isStationsError,
	} = useGetStations(axiosSecure);

	if (isStationsLoading || !allStations) {
		return <LoadingPage />;
	}

	const stationList: Array<Station> = allStations.data!;
	const stationData: Array<SelectItem> = stationList!.map((station) => {
		const id = station.stationId;
		return {
			stationType: station.stationType,
			label: station.title,
			value: id.toString(),
			description: station.city,
		};
	});
	return (
		<Center>
			<Tabs defaultValue="flight">
				<Tabs.List>
					<Tabs.Tab icon={<IconPlane size="1rem" />} value="flight">
						Flight
					</Tabs.Tab>
					<Tabs.Tab icon={<IconBus size="1rem" />} value="bus">
						Bus
					</Tabs.Tab>
					<Tabs.Tab icon={<IconBuilding size="1rem" />} value="hotel">
						Hotel
					</Tabs.Tab>
				</Tabs.List>
				<Tabs.Panel value="flight" pt="xs">
					<PlaneTab stationData={stationData} />
				</Tabs.Panel>
				<Tabs.Panel value="bus" pt="xs">
					<BusTab stationData={stationData} />
				</Tabs.Panel>
				<Tabs.Panel value="hotel" pt="xs">
					<HotelTab />
				</Tabs.Panel>
			</Tabs>
		</Center>
	);
};

export default SearchFarePage;
