
export interface GroupObject {
    id: string,
    description: string

}
export interface UserObject {
    id: string,
    description: string,
    groups: GroupObject[]
}

