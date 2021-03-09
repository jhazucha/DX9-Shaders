//*****************************************************************************
//  World Space effect techniques for rendering vector models.
//*****************************************************************************

float4x4 WorldMatrix;
float4x4 ViewMatrix;
float4x4 ProjectionMatrix;

int screenWidth = 1280;
int screenHeight = 1024;

float alpha = 1.0f;

//*****************************************************************************
struct VSInput
{
    float4 position		: POSITION;
	float4 color		: COLOR;
	float4 texcoord0	: TEXCOORD0;
};

struct VSOutput
{
    float4 position : POSITION;
	float4 color	: COLOR;
	float matAlpha	: TEXCOORD0;
};

//*****************************************************************************
VSOutput VectorModelWorldSpaceVS( VSInput vsIn )
{
	VSOutput vsOut = ( VSOutput )0;

	float r = vsIn.texcoord0.z;
	float4 col1 = float4( cos( r ),			-sin( r ),			0,	0 );
	float4 col2 = float4( sin( r ),			cos( r ),			0,	0 );
	float4 col3 = float4( 0,				0,					1,	0 );
	float4 col4 = float4( vsIn.texcoord0.x, vsIn.texcoord0.y,	0,	1 );

	float4x4 world = float4x4( col1, col2, col3, col4 );

	//Transform the position into world coordinates.
	float4 worldPosition = mul( float4( vsIn.position.x, vsIn.position.y, vsIn.position.z, 1 ), world );
	float4 viewPosition = mul( worldPosition, ViewMatrix );
	vsOut.position = mul( viewPosition, ProjectionMatrix );
	vsOut.color = vsIn.color;
	vsOut.matAlpha = vsIn.texcoord0.w;

	return vsOut;
}

float4 VectorModelWorldSpacePS( VSOutput input ) : COLOR0
{
	return( float4( input.color.rgb, input.color.a*input.matAlpha ) );
}

//*****************************************************************************
technique VectorModelWorldSpace
{
	pass P0
	{
		VertexShader = compile vs_1_1 VectorModelWorldSpaceVS( );
		PixelShader = compile ps_1_1 VectorModelWorldSpacePS( );
	}
}