from rest_framework import permissions

class OwnPermission(permissions.BasePermission):

    def has_object_permission(self, request, view, obj):
        #SAFE_METHODでGET,POSTのみ許容
        if request.method in permissions.SAFE_METHODS:
            return True
        return False
