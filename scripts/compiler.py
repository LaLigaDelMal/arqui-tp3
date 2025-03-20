import re

class Assembler:

    def tokenizer(self, program_text):
        tokens: list = []
        regex_format = (
            r'(?m)(\w+)\s+(-?\w+)\s*,\s*(-?\w+)\s*,\s*(-?\w+)\s*$'
            r'|(\w+)\s+(-?\w+)\s*,\s*(-?\w+)\s*$'
            r'|(\w+)\s+(-?\w+)\s*$'
        )

        for raw_line in program_text:
            line = raw_line.strip()
            tokens.append(list(filter(None, re.split(regex_format, line))))

        return tokens

    def to_binary(self, str: str, n_bits):
        bin_str = ''
        str = str.replace('R', '')
        num = int(str)

        if num < 0:
            bin_str = format(num & 0xffffffff, '32b')
            print(bin_str)
        else:
            bin_str = '{:032b}'.format(num)

        return bin_str[32-n_bits:]


    def set_opcode(self, inst, opcode):
        return opcode + inst[6:]

    def set_rs(self, inst, rs):
        rs = self.to_binary(rs, 5)
        return inst[0:6] + rs + inst[11:]
    
    def set_rt(self, inst, rt):
        rt = self.to_binary(rt, 5)
        return inst[0:11] + rt + inst[16:]
    
    def set_rd(self, inst, rd):
        rd = self.to_binary(rd, 5)
        return inst[0:16] + rd + inst[21:]

    def set_sa(self, inst, sa):
        sa = self.to_binary(sa, 5)
        return inst[0:21] + sa + inst[26:]

    def set_function(self, inst, function):
        return inst[0:26] + function

    def set_offset(self, inst, offset):
        offset = self.to_binary(offset, 16)
        return inst[0:16] + offset

    def set_base(self, inst, base):
        return self.set_rs(inst, base)

    def set_inmed(self, inst, inmed):
        return self.set_offset(inst, inmed)

    def set_target(self, inst, target):
        target = self.to_binary(target, 26)
        return inst[0:6] + target

    def instruction_parser(self, token):
        inst_bin = "00000000000000000000000000000000"
        i_name = token[0]
        opcode_map = {
            "SLL": "000000", "SRL": "000000", "SRA": "000000", "SLLV": "000000",
            "SRLV": "000000", "SRAV": "000000", "ADDU": "000000", "SUBU": "000000",
            "AND": "000000", "OR": "000000", "XOR": "000000", "NOR": "000000",
            "SLT": "000000", "LB": "100000", "LH": "100001", "LW": "100011", "LWU": "100111",
            "LHU": "100101", "LBU": "100100", "SB": "101000", "SH": "101001",
            "SW": "101011", "ADDI": "001000", "ANDI": "001100",
            "ORI": "001101", "XORI": "001110", "LUI": "001111", "SLTI": "001010",
            "BEQ": "000100", "BNE": "000101", "J": "000010", "JAL": "000011",
            "JR": "000000", "JALR": "000000", "NOP": "00000000000000000000000000000000",
            "HALT": "11111111111111111111111111111111"
        }

        function_map = {"SLL": "000000", "SRL": "000010", "SRA": "000011", "SLLV": "000100", "SRLV": "000110",
                        "SRAV": "000111", "ADDU": "100001", "SUBU": "100011", "AND": "100100", "OR": "100101",
                        "XOR": "100110", "NOR": "100111", "SLT": "101010", "JR": "001000", "JALR": "001001"}

        if i_name in opcode_map.keys():
            inst_bin = self.set_opcode(inst_bin, opcode_map[i_name])
            if i_name in function_map.keys():
                inst_bin = self.set_function(inst_bin, function_map[i_name])
            if i_name in ["SLL", "SRL", "SRA"]:
                inst_bin = self.set_rd(inst_bin, token[1])
                inst_bin = self.set_rt(inst_bin, token[2])
                inst_bin = self.set_sa(inst_bin, token[3])
            elif i_name in ["SLLV", "SRLV", "SRAV"]:
                inst_bin = self.set_rd(inst_bin, token[1])
                inst_bin = self.set_rt(inst_bin, token[2])
                inst_bin = self.set_rs(inst_bin, token[3])
            elif i_name in ["ADDU", "SUBU", "AND", "OR", "XOR", "NOR", "SLT"]:
                inst_bin = self.set_rd(inst_bin, token[1])
                inst_bin = self.set_rs(inst_bin, token[2])
                inst_bin = self.set_rt(inst_bin, token[3])
            elif i_name in ["LB", "LH", "LW", "LWU", "LHU", "LBU", "SB", "SH", "SW"]:
                inst_bin = self.set_rt(inst_bin, token[1])
                inst_bin = self.set_offset(inst_bin, token[2])
                inst_bin = self.set_base(inst_bin, token[3])
            elif i_name in ["ADDI", "ANDI", "ORI", "XORI", "SLTI"]:
                inst_bin = self.set_rt(inst_bin, token[1])
                inst_bin = self.set_rs(inst_bin, token[2])
                inst_bin = self.set_inmed(inst_bin, token[3])
            elif i_name == "LUI":
                inst_bin = self.set_rt(inst_bin, token[1])
                inst_bin = self.set_inmed(inst_bin, token[2])
            elif i_name in ["BEQ", "BNE"]:
                inst_bin = self.set_rs(inst_bin, token[1])
                inst_bin = self.set_rt(inst_bin, token[2])
                inst_bin = self.set_offset(inst_bin, token[3])
            elif i_name in ["J", "JAL"]:
                inst_bin = self.set_target(inst_bin, token[1])
            elif i_name == "JR":
                inst_bin = self.set_rs(inst_bin, token[1])
            elif i_name == "JALR":
                inst_bin = self.set_rd(inst_bin, token[1])
                inst_bin = self.set_rs(inst_bin, token[2])
        else:
            print(i_name, ": Not recognized instruction")

        if i_name in ["NOP", "HALT"]:
            inst_bin = opcode_map[i_name]

        return inst_bin


def main():
    binary_code: str
    instructions_tokens: list
    asm = Assembler()

    with open("./program.asm", encoding='utf-8') as source_file:
        lines = source_file.readlines()
        instructions_tokens = asm.tokenizer(lines)

    with open("./assembled.hex", "w") as d_file:
        for inst in instructions_tokens:
            binary_code = asm.instruction_parser(inst)
            print(binary_code)
            print("")
            for i in range(0, len(binary_code), 32):
                d_chunk = binary_code[i:i+32]
                hex_value = format(int(d_chunk, 2), '08x')
                d_file.write(hex_value + '\n')
        d_file.write('ffffffff')

if __name__ == "__main__":
    main()
