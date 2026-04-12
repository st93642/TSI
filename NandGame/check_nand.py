import re

with open('export.json', 'r') as f:
    content = f.read()

level_order = ["RELAY_NAND","INV","AND","OR","XOR","HALFADD","FULLADD","ADD2","INC","SUB",
               "ISZERO","SIGN","MULTIPLEXER","DEMUX","ALU_LOGIC","ALU_ARITHMETIC","ALU2",
               "CONDITION","SR_LATCH","LATCH","DFF","DFF2","COUNTER","RAM","CPU_STATE",
               "ALU_INSTRUCTION","CONTROL_SELECTOR","CONTROL_UNIT","CPU3","IO2","PROGRAM1"]

# Friendly names matching screenshots
friendly_names = {
    "RELAY_NAND": "Nand", "INV": "Invert", "AND": "And", "OR": "Or", "XOR": "Xor",
    "HALFADD": "Half Adder", "FULLADD": "Full Adder", "ADD2": "Multi-bit Adder",
    "INC": "Increment", "SUB": "Subtraction", "ISZERO": "Equal to Zero",
    "SIGN": "Less than Zero", "MULTIPLEXER": "Selector", "DEMUX": "Switch",
    "ALU_LOGIC": "Logic Unit", "ALU_ARITHMETIC": "Arithmetic Unit", "ALU2": "ALU",
    "CONDITION": "Condition", "SR_LATCH": "SR Latch", "LATCH": "D Latch",
    "DFF": "Data Flip-Flop", "DFF2": "Register", "COUNTER": "Counter", "RAM": "RAM",
    "CPU_STATE": "Combined Memory", "ALU_INSTRUCTION": "Instruction",
    "CONTROL_SELECTOR": "Control Unit", "CONTROL_UNIT": "Control Unit 2",
    "CPU3": "Computer", "IO2": "Input & Output", "PROGRAM1": "Program"
}

for lvl in level_order:
    pattern = rf'"NandGame:Levels:{re.escape(lvl)}":\{{"nodes":\[(.+?)\],"connections"'
    m = re.search(pattern, content)
    if not m:
        pattern2 = rf'"NandGame:Levels:{re.escape(lvl)}":\{{"nodes":\[(.+?)\]'
        m = re.search(pattern2, content)
    
    if m:
        nodes_str = m.group(1)
        nand_count = nodes_str.count('"type":"NAND"')
        types = re.findall(r'"type":"([^"]+)"', nodes_str)
        type_counts = {}
        for t in types:
            type_counts[t] = type_counts.get(t, 0) + 1
        print(f'{lvl} ({friendly_names.get(lvl, lvl)}): NAND={nand_count}, components={type_counts}')
    else:
        print(f'{lvl} ({friendly_names.get(lvl, lvl)}): NOT FOUND IN EXPORT')
