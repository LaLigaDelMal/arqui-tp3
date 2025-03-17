# op + reg destino + reg1 + reg2 / inmediato.
import re

class Assembler:

    def tokenizer(self, program_text):
        tokens: list = []
        regex_format = (
            r'(?m)(\w+)\s+(-?\w+)\s*,\s*(-?\w+)\s*,\s*(-?\w+)\s*$'
            r'|(\w+)\s+(-?\w+)\s*,\s*(-?\w+)\s*$'
            r'|(\w+)\s+(-?\w+)\s*$'
        )

        # Parseo las lineas, remuevo trailing y spliteo en tokens
        for raw_line in program_text:
            line = raw_line.strip()  # More efficient than .replace('\n', '')
            tokens.append(list(filter(None, re.split(regex_format, line))))

        return tokens
    
    # Convierte registros o numeros enteros, a string binario
    def to_binary(self, str, n_bits):
        bin_str = ''

        matches = re.search('R{0,1}(-{0,1}\d+)', str)
        if matches == None:
            return "No matching regex condition"

        num = int(matches[1])

        if num < 0:
            bin_str = format(num & 0xffffffff, '32b')
            print(bin_str)
        else:
            bin_str = '{:032b}'.format(num)

        return bin_str[32-n_bits:]
    
    
    def set_opcode(self, inst, opcode):
        return opcode + inst[6:]
    
    # Instrucciones Jump tienen 26b de destino
    def set_dest_jump(self, inst, dest):
        dest = self.to_binary(dest, 26)
        return inst[0:6] + dest
    
    # Instrucciones Jump tienen 16b de destino
    def set_dest_branch(self, inst, dest):
        dest = self.to_binary(dest, 16)
        return inst[0:16] + dest
    
    def set_rs(self, inst, rs):
        rs = self.to_binary(rs, 5)
        return inst[0:6] + rs + inst[11:]
    
    def set_rt(self, inst, rt):
        rt = self.to_binary(rt, 5)
        return inst[0:11] + rt + inst[16:]
    
    def set_rd(self, inst, rd):
        rd = self.to_binary(rd, 5)
        return inst[0:16] + rd + inst[21:]
    
    # Offset o Inmediato, sirve para cualquiera de los 2
    def set_inmed(self, inst, inmed):
        inmed = self.to_binary(inmed, 16)
        return inst[0:16] + inmed

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

        function_map = {}

        if i_name in opcode_map.keys():
            inst_bin = self.set_opcode(inst_bin, opcode_map[i_name])
            if i_name in ["SLL", "SRL", "SRA"]:
                inst_bin = self.set_rt(inst_bin, token[1])
                inst_bin = self.set_rs(inst_bin, token[2])
                inst_bin = self.set_inmed(inst_bin, token[3])
            elif i_name in ["SLLV", "SRLV", "SRAV", "ADDU", "SUBU", "AND", "OR", "XOR", "NOR", "SLT"]:
                inst_bin = self.set_rd(inst_bin, token[1])
                inst_bin = self.set_rs(inst_bin, token[2])
                inst_bin = self.set_rt(inst_bin, token[3])
            elif i_name in ["LB", "LH", "LW", "LHU", "LBU", "SB", "SH", "SW", "ADDI", "SUBI", "ANDI", "ORI", "XORI", "SLTI"]:
                inst_bin = self.set_rt(inst_bin, token[1])
                inst_bin = self.set_rs(inst_bin, token[2])
                inst_bin = self.set_inmed(inst_bin, token[3])
            elif i_name == "LUI":
                inst_bin = self.set_rt(inst_bin, token[1])
                inst_bin = self.set_inmed(inst_bin, token[2])
            elif i_name in ["BEQ", "BNE"]:
                inst_bin = self.set_dest_branch(inst_bin, token[1])
                inst_bin = self.set_rs(inst_bin, token[2])
                inst_bin = self.set_rt(inst_bin, token[3])
            elif i_name in ["J", "JAL"]:
                inst_bin = self.set_dest_jump(inst_bin, token[1])
            elif i_name == "JR":
                inst_bin = self.set_rs(inst_bin, token[1])
            elif i_name == "JALR":
                inst_bin = self.set_rd(inst_bin, token[1])
                inst_bin = self.set_rs(inst_bin, token[2])
        else:
            print(i_name, ": Not recognized instruction")

        return inst_bin


def main():
    # Abro el archivo, lo tokenizo, y a estos tokens los traduzco a binario.
    # El resultado se muestra por consola, tratar de implementar un .txt
    binary_code: str
    instructions_tokens: list
    asm = Assembler()

    with open("/mnt/Data/MAIN/University/Arquitectura de Computadoras/Practico/Trabajos Practicos/Processor/arqui-tp3/scripts/program.asm", encoding='utf-8') as source_file:
        lines = source_file.readlines()
        instructions_tokens = asm.tokenizer(lines)

    # En decimal
    with open("/mnt/Data/MAIN/University/Arquitectura de Computadoras/Practico/Trabajos Practicos/Processor/arqui-tp3/scripts/decimal_code.txt", "w") as d_file:
        for inst in instructions_tokens:
            binary_code = asm.instruction_parser(inst)
            for i in range(0, len(binary_code), 8):
                d_chunk = binary_code[i:i+8]
                hex_value = format(int(d_chunk, 2), '02x')
                d_file.write(hex_value + ' ')           #ESCRIBO EN EL ARCHIVO EL VALOR EN HEXADECIMAL, SEPARADO POR ESPACIO PARA QUE QUEDE EN LA MISMA LINEA
                print(hex_value, end=' ')

if __name__ == "__main__":
    main()
