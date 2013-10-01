package Routes::RoutesRole;
use OX::Role;

router as {
    route '/markers/near/radius'  => 'markers_rest_controller.find_near_markers';
};

1;