const mongoose = require("mongoose");

const DB_URI = "mongodb://open5gs-release-mongodb/open5gs";

const slice_data_template = [
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

const subscriber_template = {
  imsi: "999700000000001",
  subscribed_rau_tau_timer: 12,
  network_access_mode: 0,
  subscriber_status: 0,
  operator_determined_barring: 0,
  access_restriction_data: 32,
  slice: slice_data_template,
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

const create_subscribers_with_imsi = (number, start_imsi = 999700000000001) => {
  const subscribers = Array.from(Array(number)).map((_, index) => {
    return { ...subscriber_template, imsi: (start_imsi + index).toString() };
  });
  return subscribers;
};

const SliceSessionSchema = new mongoose.Schema({
  name: String,
  type: Number,
  pcc_rule: [],
  ambr: {
    uplink: { value: Number, unit: Number },
    downlink: { value: Number, unit: Number },
  },
  qos: {
    index: Number,
    arp: {
      priority_level: Number,
      pre_emption_capability: Number,
      pre_emption_vulnerability: Number,
    },
  },
});

const SliceSchema = new mongoose.Schema({
  sst: Number,
  default_indicator: Boolean,
  session: [SliceSessionSchema],
});

const SubscriberSchema = new mongoose.Schema({
  imsi: String,
  subscribed_rau_tau_timer: Number,
  network_access_mode: Number,
  subscriber_status: Number,
  operator_determined_barring: Number,
  access_restriction_data: Number,
  slice: [SliceSchema],
  ambr: {
    uplink: { value: Number, unit: Number },
    downlink: { value: Number, unit: Number },
  },
  security: {
    k: String,
    amf: String,
    opc: String,
  },
  schema_version: Number,
  __v: Number,
});

const save_subscribers = async (subscribers) => {
  try {
    await mongoose.connect(DB_URI);
    console.log("Db Connected");
    const SubscriberModel = mongoose.model("subscribers", SubscriberSchema);
    try {
      const BLOCK_SIZE = 10000;
      for (let i = 0; i < subscribers.length; ) {
        const nextStartIndex = i + BLOCK_SIZE;
        const subscribersToSave = subscribers.slice(i, nextStartIndex);
        const result = await SubscriberModel.insertMany(subscribersToSave);
        console.log(result);
        i = nextStartIndex;
      }
    } catch (error) {
      console.error(error);
      console.error("error bulk saving");
    } finally {
      mongoose.disconnect();
    }
  } catch (error) {
    console.error(error);
    console.error("Unable to connect to the DB");
  }
};

const subscribers = create_subscribers_with_imsi(200000);
console.log(subscribers);

save_subscribers(subscribers);
