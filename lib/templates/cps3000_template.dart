class CPS3000Template {

  static Map<String, List<String>> sections = {

    "Enclosure": [
      "Enclosure Serial No. 1",
      "Enclosure Serial No. 2"
    ],

    "Fan Box": [
      "Fan1",
      "NTC8 – Fan1 – 10K",
      "Fan2",
      "NTC10 – Fan2 – 10K"
    ],

    "Magnetics": [
      "L1",
      "TR1",
      "TR2",
      "L2",
      "TR3"
    ],

    "Switchgears": [
      "CB01",
      "CB02",
      "K1",
      "K2",
      "K3",
      "K4",
      "K5",
      "K6",
      "K7",
      "K8",
      "SPD3 – AC SPD",
      "SPD4 – AC SPD AUX",
      "SPD1 – DC SPD",
      "SPD2 – DC SPD",
      "FU1",
      "FU2",
      "FU3",
      "FU4",
      "ETH2 – ETH SWITCH",
      "CBF",
      "CBF1",
      "CBF2"
    ],

    "Sensors": [
      "HCTU1",
      "HCTV1",
      "HCTW1",
      "HCTU2",
      "HCTV2",
      "HCTW2",
      "HCTU3",
      "HCTV3",
      "HCTW3",
      "HCTU4",
      "HCTV4",
      "HCTW4",
      "HCTD1",
      "HCTD2",
      "NTC7 – P1 – 10K",
      "NTC9 – P2 – 10K",
      "A8-1 PT Sensing Board",
      "A8-2 PT Sensing Board"
    ],

    "Resistors": [
      "RA18 – 66KΩ 100W",
      "RA19 – 66KΩ 100W",
      "RA20 – 66KΩ 100W",
      "RA1 – 80E 500W",
      "RA2 – 80E 500W",
      "RA3 – 33KΩ 100W",
      "RA4 – 33KΩ 100W",
      "RA5 – 33KΩ 100W",
      "RA6 – 33KΩ 100W",
      "RA15 – 66KΩ 100W",
      "RA16 – 66KΩ 100W",
      "RA17 – 66KΩ 100W"
    ],

    "PCB": [
      "A2-1 Interface Card",
      "A3-1 Controller Card",
      "A6-1 CB Card 1",
      "A7-1 Gate Interlock Card",
      "A7-2 Gate Interlock Card",
      "A7-3 Gate Interlock Card",
      "A12 AC Filter Card",
      "A13-1 DC Filter",
      "A1 Domain Controller",
      "A2-2 Interface Card",
      "A3-2 Controller Card",
      "A3-3 Controller Card",
      "A5 Power Supply ORing Card",
      "A5-1 Power Supply ORing Card",
      "A6-2 CB Card 2",
      "A7-4 Gate Interlock Card",
      "A7-5 Gate Interlock Card",
      "A7-6 Gate Interlock Card",
      "A10 SIM100",
      "A11 Data Logger",
      "A13-2 DC Filter"
    ],

    "Capacitor": [
      "Cap Bank CF1",
      "Cap Bank CF2",
      "Cap Bank CF3",
      "Cap Bank CF4",
      "Cap Bank CF5",
      "Cap Bank CF6"
    ],

    "Power Supply": [
      "PS1 – 24V",
      "PS3 – 24V",
      "PS4 – 15V",
      "PS5 – 12V",
      "PS9 – 24V",
      "PS2 – 24V",
      "PS6 – 24V",
      "PS7 – 15V",
      "PS8 – +/-12V",
      "PS10 – 15V",
      "HMI"
    ],

    "U1 STACK": [
      "A4-1",
      "A4-2",
      "IGBT1",
      "IGBT2",
      "IGBT3",
      "IGBT4",
      "TS1 – 120°C",
      "TS2 – 120°C",
      "CD1-8",
      "NTC1 – 10K",
      "SKYPER1-U1",
      "SKYPER2-U1",
      "SKYPER3-U1",
      "SKYPER4-U1"
    ],

    "V1 STACK": [
      "A4-3",
      "A4-4",
      "IGBT5",
      "IGBT6",
      "IGBT7",
      "IGBT8",
      "TS3 – 120°C",
      "TS4 – 120°C",
      "CD9-16",
      "NTC2 – 10K",
      "SKYPER1-V1",
      "SKYPER2-V1",
      "SKYPER3-V1",
      "SKYPER4-V1"
    ],

    "W1 STACK": [
      "A4-5",
      "A4-6",
      "IGBT9",
      "IGBT10",
      "IGBT11",
      "IGBT12",
      "TS5 – 120°C",
      "TS6 – 120°C",
      "CD17-24",
      "NTC3 – 10K",
      "SKYPER1-W1",
      "SKYPER2-W1",
      "SKYPER3-W1",
      "SKYPER4-W1"
    ],

    "U2 STACK": [
      "A4-7",
      "A4-8",
      "IGBT13",
      "IGBT14",
      "IGBT15",
      "IGBT16",
      "TS7 – 120°C",
      "TS8 – 120°C",
      "CD25-32",
      "NTC4 – 10K",
      "SKYPER1-U2",
      "SKYPER2-U2",
      "SKYPER3-U2",
      "SKYPER4-U2"
    ],

    "V2 STACK": [
      "A4-9",
      "A4-10",
      "IGBT17",
      "IGBT18",
      "IGBT19",
      "IGBT20",
      "TS9 – 120°C",
      "TS10 – 120°C",
      "CD33-40",
      "NTC5 – 10K",
      "SKYPER1-V2",
      "SKYPER2-V2",
      "SKYPER3-V2",
      "SKYPER4-V2"
    ],

    "W2 STACK": [
      "A4-11",
      "A4-12",
      "IGBT21",
      "IGBT22",
      "IGBT23",
      "IGBT24",
      "TS11 – 120°C",
      "TS12 – 120°C",
      "CD41-48",
      "NTC6 – 10K",
      "SKYPER1-W2",
      "SKYPER2-W2",
      "SKYPER3-W2",
      "SKYPER4-W2"
    ],

  };

}