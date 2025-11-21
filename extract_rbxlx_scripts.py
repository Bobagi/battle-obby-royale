import os
import sys
import xml.etree.ElementTree as ET


def safe_name(raw_name: str) -> str:
    filtered_name = "".join(character for character in raw_name if character.isalnum() or character in "-_")
    return filtered_name.strip() or "Unnamed"


def collect_scripts_from_rbxlx(xml_root: ET.Element) -> list[tuple[str, str, str, list[str]]]:
    collected_scripts: list[tuple[str, str, str, list[str]]] = []
    walk_items(xml_root, [], collected_scripts)
    return collected_scripts


def walk_items(current_element: ET.Element, current_path: list[str], collected_scripts: list[tuple[str, str, str, list[str]]]) -> None:
    for child_element in current_element:
        if child_element.tag != "Item":
            walk_items(child_element, current_path, collected_scripts)
            continue

        properties_element = child_element.find("Properties")

        name_text = None
        if properties_element is not None:
            for property_element in properties_element.findall("string"):
                if property_element.get("name") == "Name":
                    name_text = property_element.text
                    break

        instance_name = name_text if name_text is not None else child_element.get("class") or "Unnamed"
        new_path = current_path + [instance_name]

        class_name = child_element.get("class")
        if class_name in ("Script", "LocalScript", "ModuleScript"):
            source_code = ""
            if properties_element is not None:
                for property_element in properties_element:
                    if property_element.tag == "ProtectedString" and property_element.get("name") == "Source":
                        source_code = property_element.text or ""
                        break
            collected_scripts.append((class_name, instance_name, source_code, new_path))

        walk_items(child_element, new_path, collected_scripts)


def write_scripts_to_output_directory(collected_scripts: list[tuple[str, str, str, list[str]]], output_directory: str) -> None:
    for class_name, instance_name, source_code, full_path in collected_scripts:
        cleaned_parent_names = [safe_name(name) for name in full_path[:-1]]
        cleaned_file_name = safe_name(full_path[-1])

        directory_path_parts = [output_directory] + cleaned_parent_names
        directory_path = os.path.join(*directory_path_parts)
        os.makedirs(directory_path, exist_ok=True)

        file_path = os.path.join(directory_path, cleaned_file_name + ".lua")
        with open(file_path, "w", encoding="utf-8") as file_handle:
            file_handle.write(source_code)


def main() -> None:
    if len(sys.argv) >= 2:
        input_file_path = sys.argv[1]
    else:
        input_file_path = "place.rbxlx"

    if len(sys.argv) >= 3:
        output_directory = sys.argv[2]
    else:
        output_directory = "out"

    tree = ET.parse(input_file_path)
    root = tree.getroot()

    collected_scripts = collect_scripts_from_rbxlx(root)
    write_scripts_to_output_directory(collected_scripts, output_directory)


if __name__ == "__main__":
    main()
