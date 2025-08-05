import { Permissions } from "../../common/enums/permissions.enum";
import { Role } from "../../common/enums/roles.enum";


export const getRoleDefaultPermissions = (role, forSeeder = false) => {

    let permission = [];

    switch (role) {
        case Role.SUPER_ADMIN:
            permission = Object.values(Permissions);
            break;
        case Role.ADMIN:
            permission = [
                // user permissions
                Permissions.READ_USER,
                Permissions.CREATE_USER,
                Permissions.UPDATE_USER,
                Permissions.DELETE_USER,

                // project permissions
                Permissions.READ_PROJECT,
                Permissions.CREATE_PROJECT,
                Permissions.UPDATE_PROJECT,
                Permissions.DELETE_PROJECT,

                // spring permissions
                Permissions.READ_SPRINT,
                Permissions.CREATE_SPRINT,
                Permissions.UPDATE_SPRINT,
                Permissions.DELETE_SPRINT,

                // task permissions
                Permissions.READ_TASK,
                Permissions.CREATE_TASK,
                Permissions.UPDATE_TASK,
                Permissions.DELETE_TASK,

                // role permissions
                Permissions.READ_ROLE,
                Permissions.CREATE_ROLE,
                Permissions.UPDATE_ROLE,
                Permissions.DELETE_ROLE,

                // team permissions
                Permissions.READ_TEAM,
                Permissions.CREATE_TEAM,
                Permissions.UPDATE_TEAM,
                Permissions.DELETE_TEAM,

                // tenant permissions
                Permissions.UPDATE_TENANT,
            ]
            break;
        case Role.PROJECT_MANAGER:
            permission = [
                // project permissions
                Permissions.READ_PROJECT,
                Permissions.CREATE_PROJECT,
                Permissions.UPDATE_PROJECT,
                Permissions.DELETE_PROJECT,

                // spring permissions
                Permissions.READ_SPRINT,
                Permissions.CREATE_SPRINT,
                Permissions.UPDATE_SPRINT,
                Permissions.DELETE_SPRINT,

                // task permissions
                Permissions.READ_TASK,
                Permissions.CREATE_TASK,
                Permissions.UPDATE_TASK,
                Permissions.DELETE_TASK,

                // team permissions
                Permissions.READ_TEAM,
                Permissions.UPDATE_TEAM,
                Permissions.DELETE_TEAM,
            ]
            break;
        case Role.TEAM_LEAD:
            permission = [
                // project permissions
                Permissions.READ_PROJECT,

                // spring permissions
                Permissions.READ_SPRINT,

                // task permissions
                Permissions.READ_TASK,
                Permissions.UPDATE_TASK,

                // team permissions
                Permissions.READ_TEAM,
                Permissions.UPDATE_TEAM,
            ]
            break;
        case Role.TEAM_MEMBER:
            permission = [
                // project permissions
                Permissions.READ_PROJECT,

                // spring permissions
                Permissions.READ_SPRINT,

                // task permissions
                Permissions.READ_TASK,
                Permissions.UPDATE_TASK,

                // team permissions
                Permissions.READ_TEAM,
            ]
        break;
    }

    if (forSeeder) {
        return permission.map(el => ({
            name: el,
            permission_type: el.split("_").shift(),
            feature: `${el.split('_').pop()} MANAGEMENT`,
            isGlobal: [Role.SUPER_ADMIN, Role.ADMIN].includes(role),
        }));
    }

    return permission;
}