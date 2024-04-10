slice_data = [
  {
    sst: 1,
    default_indicator: true,
    session: [
      {
        name: "internet",
        type: 3,
        pcc_rule: [],
        ambr: {
          uplink: { value: 1, unit: 3 },
          downlink: { value: 1, unit: 3 },
        },
        qos: {
          index: 9,
          arp: {
            priority_level: 8,
            pre_emption_capability: 1,
            pre_emption_vulnerability: 1,
          },
        },
      },
    ],
  },
];

sub_data = {
  imsi: "999700000000001",
  subscribed_rau_tau_timer: 12,
  network_access_mode: 0,
  subscriber_status: 0,
  operator_determined_barring: 0,
  access_restriction_data: 32,
  slice: slice_data,
  ambr: { uplink: { value: 1, unit: 3 }, downlink: { value: 1, unit: 3 } },
  security: {
    k: "465B5CE8 B199B49F AA5F0A2E E238A6BC",
    amf: "8000",
    op: null,
    opc: "E8ED289D EBA952E4 283B54E8 8E6183CA",
  },
  schema_version: 1,
  __v: 0,
};

create_subscribers_with_imsi = (number, start_imsi = 999700000000001) => {
  const subscribers = Array.from(Array(number)).map((_, index) => {
    return { ...sub_data, imsi: (start_imsi + index).toString() };
  });
  return subscribers;
};
